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
              label: "Delete Tap Marker",
              child: const Icon(
                Icons.delete,
              ),
              onTap: () =>
                  MarkerMapController.instance.deleteMarkersExceptFixed()),
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
