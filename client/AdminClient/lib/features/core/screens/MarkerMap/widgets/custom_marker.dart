import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/images_strings.dart';

// ignore: must_be_immutable
class CircularWidget extends StatelessWidget {
  CircularWidget({super.key, required this.imageFile});

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    print("Image File: $imageFile");
    return Container(
      width: 100,
      height: 115,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: imageFile != null
            ? Image(
                image: Image.file(imageFile!).image,
                fit: BoxFit.cover,
              )
            : const Image(
                image: AssetImage(MyAppImages.profile2),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
