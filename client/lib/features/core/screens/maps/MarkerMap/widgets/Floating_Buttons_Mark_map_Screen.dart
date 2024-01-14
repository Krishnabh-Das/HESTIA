import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';

class FloatingButtonsMarkerMapScreen extends StatelessWidget {
  const FloatingButtonsMarkerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 120,
      child: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        buttonSize: Size(45, 45),
        childrenButtonSize: Size(42, 42),
        spacing: 15,
        children: [
          SpeedDialChild(
            label: "Logout",
            child: Icon(
              Icons.logout,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginScreen());
            },
          ),
          SpeedDialChild(
            label: "Region Map",
            child: Icon(
              Icons.change_circle,
            ),
            onTap: () => MarkerMapController.instance.toggleShowPolygon(),
          ),
          SpeedDialChild(
              label: "Delete Marker",
              child: Icon(
                Icons.delete,
              ),
              onTap: () =>
                  MarkerMapController.instance.deleteMarkersExceptFixed()),
          SpeedDialChild(
              label: "Gallery",
              child: Icon(Icons.photo),
              onTap: () => MarkerMapController.instance.getImage(false)),
          SpeedDialChild(
            label: "Camera",
            child: Icon(Icons.camera_alt),
            onTap: () => MarkerMapController.instance.getImage(true),
          ),
          SpeedDialChild(
              label: "Current Location",
              child: Icon(Icons.track_changes_outlined),
              onTap: () => MarkerMapController.instance.moveToCurrLocation(
                  settingsController.instance.profileImage.value)),
          SpeedDialChild(
            label: "Change Map",
            child: Icon(Icons.map),
            onTap: () => MarkerMapController.instance.toggleMap(),
          ),
        ],
      ),
    );
  }
}
