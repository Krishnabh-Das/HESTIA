import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/controllers/signup_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:hestia/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class SignupTextField extends StatelessWidget {
  SignupTextField({
    super.key,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  TextEditingController email, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    final dark = MyAppHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        TextFormField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail_outline),
            labelText: "Email ID",
            labelStyle: TextStyle(
              color: dark ? MyAppColors.textWhite : MyAppColors.dark,
            ),
          ),
          validator: (value) {
            MyAppValidator.validateEmail(value);
            return null;
          },
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwInputFields,
        ),
        Obx(
          () => TextFormField(
            controller: password,
            keyboardType: TextInputType.visiblePassword,
            obscureText:
                SignupController.instance.signUpPasswordObscureText.value,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                  onPressed: () => SignupController.instance
                      .toggleSignUpPasswordObscureText(),
                  icon:
                      SignupController.instance.signUpPasswordObscureText.value
                          ? const Icon(Iconsax.eye_slash)
                          : const Icon(Iconsax.eye)),
              labelText: "Password",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
            validator: (value) {
              MyAppValidator.validatePassword(value);
              return null;
            },
          ),
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwInputFields,
        ),
        Obx(
          () => TextFormField(
            controller: confirmPassword,
            keyboardType: TextInputType.visiblePassword,
            obscureText: SignupController
                .instance.signUpConfirmPasswordObscureText.value,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                  onPressed: () => SignupController.instance
                      .toggleSignUpConfirmPasswordObscureText(),
                  icon: SignupController
                          .instance.signUpConfirmPasswordObscureText.value
                      ? const Icon(Iconsax.eye_slash)
                      : const Icon(Iconsax.eye)),
              labelText: "Confirm Password",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
            validator: (value) {
              if (value != password.text.toString()) {
                return "Password & Confirm Password doesn't match";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
