import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class authenticationRichText extends StatelessWidget {
  const authenticationRichText({
    super.key,
    required this.text,
    required this.OnPressText,
    this.onTap,
  });

  final String text;
  final String OnPressText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = MyAppHelperFunctions.isDarkMode(context);
    return Center(
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: dark ? MyAppColors.textWhite : MyAppColors.dark,
                fontSize: 14)),
        TextSpan(
            text: OnPressText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: MyAppColors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w600),
            recognizer: TapGestureRecognizer()..onTap = onTap),
      ])),
    );
  }
}
