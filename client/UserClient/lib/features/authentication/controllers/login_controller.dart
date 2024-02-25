import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/bottom_nav_bar.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:iconsax/iconsax.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final AuthRepository _auth = AuthRepository();

  var email = TextEditingController();
  var password = TextEditingController();
  Rx<bool> loginObscureText = true.obs;

  String get emailString => email.text;
  String get passwordString => password.text;

  void toggleLoginObscureText() {
    loginObscureText.value = !loginObscureText.value;
  }

  void signin(BuildContext context) async {
    debugPrint("Signing In...");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailString,
        password: passwordString,
      );

      if (_auth.auth.currentUser!.emailVerified) {
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          MarkerMapController.instance.initData();
        }
        showCustomToast(context,
            color: Colors.green.shade400,
            text: "Login Successful",
            icon: Iconsax.tick_circle);
        Get.offAll(() => const BottomNavBar());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Error signing in: $e");
      // ignore: use_build_context_synchronously
      showCustomToast(context,
          color: Colors.red.shade400, text: e.code, icon: Iconsax.close_square);
    }
  }
}
