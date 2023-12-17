import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/MapScreen.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final AuthRepository _auth = AuthRepository();

  var email = TextEditingController();
  var password = TextEditingController();

  String get emailString => email.text;
  String get passwordString => password.text;

  void signin() async {
    print("Signing In...");
    _auth.signInWithEmailAndPassword(
      emailString,
      passwordString,
      () {
        if (_auth.auth.currentUser!.emailVerified) {
          Get.offAll(() => MarkerMapScreen(key: UniqueKey()));
        }
      },
    );
  }
}
