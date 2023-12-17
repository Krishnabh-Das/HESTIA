import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/Floating_Buttons_Mark_map_Screen.dart';

// ignore: must_be_immutable
class MarkerMapScreen extends StatelessWidget {
  // --- MAP CONTROLLER
  var controller = Get.put(MarkerMapController());

  MarkerMapScreen({super.key}) {
    controller.getUserLocation();
    controller.makeMarkersFromJson();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
        body: Obx(
      () => controller.currPos.value == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: <Widget>[
                // -- Google Map
                GoogleMap(
                  onMapCreated: (controller) {
                    MarkerMapController.instance.googleMapController =
                        controller;
                    MarkerMapController.instance
                        .updateGoogleControllerForCustomInfoWindowController(
                            controller);
                    MarkerMapController.instance.tapPosition =
                        MarkerMapController.instance.currPos.value;
                  },
                  initialCameraPosition: CameraPosition(
                      target: controller.currPos.value!, zoom: 16),
                  onTap: (latLng) {
                    controller
                        .customInfoWindowController.value.hideInfoWindow!();
                    controller.addTapMarkers(latLng, controller.id++);
                    controller.tapPosition = latLng;
                  },
                  onCameraMove: (position) {
                    controller.customInfoWindowController.value.onCameraMove!();
                  },
                  mapType: controller.currentMapType,
                  markers: MarkerMapController.instance.markers.value,
                  polygons: Set<Polygon>.of(controller.showPolygon.value
                      ? controller.polygons.value
                      : []),
                ),

                // --Info Window
                CustomInfoWindow(
                  controller: controller.customInfoWindowController.value,
                  width: 230,
                  height: 220,
                  offset: 35,
                ),

                // -- Floating Buttons
                const FloatingButtonsMarkerMapScreen(),
              ],
            ),
    ));
  }
}
