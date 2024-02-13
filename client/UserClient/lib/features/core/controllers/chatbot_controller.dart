import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hestia/utils/formatters/formatter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ChatBotController extends GetxController {
  static ChatBotController get instance => Get.find();

  Rx<bool> isMsgTyped = false.obs;

  RxList<List<String>> msgList = [
    [
      "Hello, my name is Hestia! I'm here to guide you. Is there anything particular you'd like to know about homelessness?",
      "c",
      "Now" // If Text Generated Now than animate otherwise Not
    ],
  ].obs;

  Future<void> uploadAndGetResponseFromChatbot(String userMsg) async {
    try {
      var url =
          Uri.https('hestiabackend-vu6qon67ia-el.a.run.app', '/chat/send');

      var payload = {
        "question": userMsg,
        "user": FirebaseAuth.instance.currentUser!.uid
      };

      var body = json.encode(payload);

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        ChatBotController.instance.isMsgTyped.value = false;
        var formattedReply =
            MyAppFormatter.formatStringSpaces(jsonResponse['reply']);
        ChatBotController.instance.msgList.add([formattedReply, "c", "Now"]);
        debugPrint("Reply: ${jsonResponse['reply']}");
      } else {
        debugPrint("Request failed with status: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("ChatBot Error: $error");
    }
  }
}
