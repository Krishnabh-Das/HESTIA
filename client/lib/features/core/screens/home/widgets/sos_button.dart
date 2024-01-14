import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/screens/home/sos/sos_screen.dart';

class halfMapSOS extends StatelessWidget {
  const halfMapSOS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 115,
      right: 7,
      child: InkWell(
        onTap: () => Get.to(
          () => const SOSScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 600),
        ),
        child: Container(
            height: 48,
            padding: const EdgeInsets.fromLTRB(12, 10, 7, 6),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const Image(
              image: AssetImage("assets/icons/megaphone.png"),
            )),
      ),
    );
  }
}
