import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class ElevatedButtonWithIcon extends StatelessWidget {
  const ElevatedButtonWithIcon({
    super.key,
    this.padding = 10,
    this.backgroundColor = MyAppColors.primary,
    required this.onPressed,
    this.image = MyAppImages.markerImage,
    required this.text,
  });

  final double padding;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String image, text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(padding),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Image(
              image: AssetImage(image),
              fit: BoxFit.fitHeight,
              height: 18,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
