import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/widgets/Screen/success.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/authentication/screens/password_configuration/widgets/reset_password_heading.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

// ignore: must_be_immutable
class VerifyAuthentication extends StatelessWidget {
  bool isEmailVerified = false;
  Timer? timer;
  final AuthRepository _auth = AuthRepository();

  VerifyAuthentication({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  }) : super(key: key) {
    // Email Verification
    _auth.sendEmailVerification();

    // Periodic email verification check
    timer =
        Timer.periodic(const Duration(seconds: 2), (_) => checkEmailVerified());
  }

  final String image;
  final String title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MyAppSizes.defaultSpace),
          child: Column(
            children: [
              // --Image
              Image(
                image: AssetImage(image),
                width: MyAppHelperFunctions.screenWidth(),
              ),

              const SizedBox(
                height: MyAppSizes.spaceBtwSections,
              ),

              // --Title & Subtitle
              ResetPasswordHeading(title: title, subtitle: subtitle),

              TextButton(
                  onPressed: () => _auth.sendEmailVerification(),
                  child: Text(buttonText))
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------- Functions ---------------------------------------

  checkEmailVerified() async {
    await _auth.auth.currentUser?.reload();

    isEmailVerified = _auth.auth.currentUser!.emailVerified;

    if (isEmailVerified) {
      // Stop the timer when email is verified
      timer?.cancel();

      // Navigate to success screen after email verification
      Get.off(() => SuccessScreen(
            image: MyAppImages.gif_verification,
            title: "Verified",
            subtitle:
                "Congratulations, your account has been verified. Now go back to the login page and Sign In using the credentials.",
            onPressed: () => Get.offAll(() => LoginScreen()),
          ));
    }
  }
}
