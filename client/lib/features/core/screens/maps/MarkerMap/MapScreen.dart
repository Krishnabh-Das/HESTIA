import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/Floating_Buttons_Mark_map_Screen.dart';

class MarkerMapScreen extends StatelessWidget {
  // --- MAP CONTROLLER
  final MarkerMapController markerMapController = Get.find();

  MarkerMapScreen({super.key}) {
    _initData();
  }

  Future<void> _initData() async {
    print("Init is called");
    await markerMapController.getUserLocation();
    await markerMapController.makeMarkersFromJson();
  }

  @override
  Widget build(BuildContext context) {
    markerMapController.context = context;

    return Scaffold(
        body: Obx(
      () => markerMapController.currPos.value == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: <Widget>[
                // -- Google Map
                GoogleMap(
                  onMapCreated: (controller) {
                    markerMapController.googleMapController = controller;
                    markerMapController
                        .updateGoogleControllerForCustomInfoWindowController(
                            controller);
                    markerMapController.tapPosition =
                        markerMapController.currPos.value;
                  },
                  initialCameraPosition: CameraPosition(
                      target: markerMapController.currPos.value!, zoom: 16),
                  onTap: (latLng) {
                    markerMapController
                        .customInfoWindowController.value.hideInfoWindow!();
                    if (markerMapController.IsInfoWindowOpen.value == false) {
                      markerMapController.changeValueOfInfoWindowOpen(true);
                      markerMapController.addTapMarkers(
                          latLng, markerMapController.id++);
                      markerMapController.tapPosition = latLng;
                    }
                    markerMapController.changeValueOfInfoWindowOpen(false);
                  },
                  onCameraMove: (position) {
                    markerMapController
                        .customInfoWindowController.value.onCameraMove!();
                  },
                  mapType: markerMapController.currentMapType,
                  markers: MarkerMapController.instance.markers.value,
                  polygons: Set<Polygon>.of(
                      markerMapController.showPolygon.value
                          ? markerMapController.polygons.value
                          : []),
                ),

                // --Info Window
                CustomInfoWindow(
                  controller:
                      markerMapController.customInfoWindowController.value,
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
