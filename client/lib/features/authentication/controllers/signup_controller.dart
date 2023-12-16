import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/constants/text_strings.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final AuthRepository _auth = AuthRepository();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  String get emailString => email.text;
  String get passwordString => password.text;
  String get confirmPasswordString => confirmPassword.text;

  void signup() async {
    if (passwordString != confirmPasswordString) {
      print("Password & Confirm Password doesn't match");
      return null;
    }

    print("Signing up...");
    _auth.signUpWithEmailAndPassword(
        emailString,
        passwordString,
        () => Get.to(() => VerifyAuthentication(
              buttonText: MyAppTexts.resendEmail,
              image: MyAppImages.email_verification,
              title: "Verify Your Email",
              subtitle:
                  "Go to your G-Mail and click on the link to verify your account.",
            )));
  }
}
