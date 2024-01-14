import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/MapScreen.dart';

class halfMapMoveToMarkerScreen extends StatelessWidget {
  const halfMapMoveToMarkerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 240,
      right: 7,
      child: Container(
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
              ))),
    );
  }
}
