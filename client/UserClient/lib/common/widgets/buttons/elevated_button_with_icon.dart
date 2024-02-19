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
    this.isImage = false,
    this.textColor = Colors.white,
    this.borderColor,
  });

  final double padding;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String image, text;
  final bool isImage;
  final Color? textColor, borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(padding),
          backgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : const BorderSide(color: MyAppColors.primary),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            isImage
                ? Image(
                    image: AssetImage(image),
                    fit: BoxFit.fitHeight,
                    height: 18,
                  )
                : const SizedBox(),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 13, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
