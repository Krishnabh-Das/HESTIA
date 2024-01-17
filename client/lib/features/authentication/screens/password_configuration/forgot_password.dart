import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/widgets/appbar/appbar.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/authentication/screens/password_configuration/widgets/forgot_password_heading.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appBar(
        actions: [],
        showBackArrow: true,
        padding: EdgeInsets.symmetric(horizontal: 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MyAppSizes.defaultSpace * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --Headings
              const ForgotPasswordHeading(),

              // --E-Mail
              SizedBox(
                height: MyAppSizes.textFormFieldHeight,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: MyAppTexts.email,
                      prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),

              const SizedBox(
                height: MyAppSizes.spaceBtwSections * 0.7,
              ),

              ///Submit Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: emailController.text.toString())
                            .then((value) {
                          Get.off(() => LoginScreen());
                        }).onError((error, stackTrace) {
                          print("Forgot Password Error: $error");
                        });
                      },
                      child: Text(
                        MyAppTexts.submit,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: MyAppColors.textWhite),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
