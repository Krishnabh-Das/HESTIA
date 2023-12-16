import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
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
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline),
              labelText: "Email ID",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwInputFields,
        ),
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: password,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: const Icon(Iconsax.eye),
              labelText: "Password",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwInputFields,
        ),
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: confirmPassword,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: const Icon(Iconsax.eye),
              labelText: "Confirm Password",
              labelStyle: TextStyle(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
