import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
        animatedIconTheme: const IconThemeData(color: Colors.white),
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        backgroundColor: const Color(0xFF1F616B),
        buttonSize: const Size(45, 45),
        childrenButtonSize: const Size(42, 42),
        spacing: 15,
        children: [
          SpeedDialChild(
            label: "Region Map",
            child: const Icon(
              Icons.change_circle,
            ),
            onTap: () => MarkerMapController.instance.toggleShowPolygon(),
          ),
          SpeedDialChild(
              label: "Delete Marker",
              child: const Icon(
                Icons.delete,
              ),
              onTap: () =>
                  MarkerMapController.instance.deleteMarkersExceptFixed()),
          SpeedDialChild(
              label: "Submit by Gallery",
              child: const Icon(Icons.photo),
              onTap: () => MarkerMapController.instance.getImage(false)),
          SpeedDialChild(
            label: "Submit by Camera",
            child: const Icon(Icons.camera_alt),
            onTap: () => MarkerMapController.instance.getImage(true),
          ),
          SpeedDialChild(
              label: "Current Location",
              child: const Icon(Icons.track_changes_outlined),
              onTap: () => MarkerMapController.instance.moveToCurrLocation(
                  settingsController.instance.profileImage.value)),
          SpeedDialChild(
            label: "Change Map",
            child: const Icon(Icons.map),
            onTap: () => MarkerMapController.instance.toggleMap(),
          ),
        ],
      ),
    );
  }
}
