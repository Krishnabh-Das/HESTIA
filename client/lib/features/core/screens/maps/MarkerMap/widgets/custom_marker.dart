import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class HexagonWidget extends StatelessWidget {
  final String imagePath;

  const HexagonWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 115,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
