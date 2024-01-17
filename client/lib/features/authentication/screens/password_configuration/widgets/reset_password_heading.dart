import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/sizes.dart';

class ResetPasswordHeading extends StatelessWidget {
  const ResetPasswordHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwItems,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: MyAppSizes.spaceBtwSections,
        ),
      ],
    );
  }
}
