import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/bottom_nav_bar.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        MarkerMapController.instance.markers.value.clear();
        HalfMapController.instance.allHalfMapMarkers.value.clear();
        await FirebaseAuth.instance.signOut();
        NavigationController.instance.selectedIndex.value = 0;
        Get.offAll(() => LoginScreen());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.redAccent),
        child: Center(
          child: Text(
            "Log Out",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
