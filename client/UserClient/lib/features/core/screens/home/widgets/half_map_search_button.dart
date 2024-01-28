import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/screens/splash_screen.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class halfMapSearchButton extends StatelessWidget {
  const halfMapSearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 7,
      child: Container(
          height: 45,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.search_normal,
                color: MyAppColors.darkBlack,
                size: 20,
              ))),
    );
  }
}
