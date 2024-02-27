import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/screens/MarkerMap/MapScreen.dart';

class halfMapMoveToMarkerScreen extends StatelessWidget {
  const halfMapMoveToMarkerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90,
      right: 7,
      child: Container(
          height: 45,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: IconButton(
              onPressed: () => Get.to(
                    () => MarkerMapScreen(),
                    transition: Transition.topLevel,
                    duration: const Duration(milliseconds: 1000),
                  ),
              icon: const Icon(
                Icons.pin_drop_rounded,
                color: Colors.redAccent,
                size: 25,
              ))),
    );
  }
}
