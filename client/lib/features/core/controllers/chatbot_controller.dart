import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ChatBotController extends GetxController {
  static ChatBotController get instance => Get.find();

  Rx<bool> isMsgTyped = false.obs;

  RxList<List<String>> msgList = [
    [
      "Hello, my name is Hestia! I'm here to guide you. Is there anything particular you'd like to know about homelessness?",
      "c"
    ],
  ].obs;

  Future<void> uploadAndGetResponseFromChatbot(String userMsg) async {
    try {
      var url = Uri.http('hestia-xzg1.onrender.com', '/chat/send');

      var payload = {
        "question": userMsg,
        "user": FirebaseAuth.instance.currentUser!.uid
      };

      var body = json.encode(payload);

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ChatBotController.instance.isMsgTyped.value = false;
        ChatBotController.instance.msgList.add([jsonResponse['reply'], "c"]);
        print("Reply: ${jsonResponse['reply']}");
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (error) {
      print("ChatBot Error: $error");
    }
  }
}
