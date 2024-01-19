import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/constants/text_strings.dart';

class ForgotPasswordHeading extends StatelessWidget {
  const ForgotPasswordHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          MyAppTexts.forgetPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwItems,
        ),
        Text(
          MyAppTexts.forgetPasswordSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwSections,
        ),
      ],
    );
  }
}
