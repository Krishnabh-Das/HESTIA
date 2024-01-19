import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/controllers/login_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:hestia/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class LoginTextField extends StatelessWidget {
  LoginTextField({
    super.key,
    required this.email,
    required this.password,
  });

  TextEditingController email, password;

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
            obscureText: LoginController.instance.loginObscureText.value,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                  onPressed: () =>
                      LoginController.instance.toggleLoginObscureText(),
                  icon: LoginController.instance.loginObscureText.value
                      ? const Icon(Iconsax.eye_slash)
                      : const Icon(Iconsax.eye)),
              labelText: "Password",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Password';
              }
              if (value.length < 6) {
                return "Password should be of length 6 or more";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
