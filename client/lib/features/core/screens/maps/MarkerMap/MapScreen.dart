import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/Floating_Buttons_Mark_map_Screen.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/search_bar.dart';
import 'package:hestia/utils/constants/api_constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

var uuid = Uuid();

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
    markerMapController.searchController.addListener(() {
      markerMapController.onChange(uuid);
    });
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
                    if (markerMapController.IsInfoWindowOpen.value == false &&
                        !markerMapController.isSearchBarVisible.value) {
                      markerMapController.addTapMarkers(
                          latLng, markerMapController.id++);
                      markerMapController.tapPosition = latLng;
                    }
                    markerMapController.changeValueOfInfoWindowOpen(false);
                    markerMapController.isSearchBarVisible.value =
                        false; // For Search Bar
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

                // -- Search Bar
                if (!markerMapController.isSearchBarVisible.value) ...[
                  Positioned(
                    top: 80,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          markerMapController.isSearchBarVisible.value = true;
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ] else if (markerMapController.isSearchBarVisible.value) ...[
                  searchBar(markerMapController: markerMapController),
                ],

                // -- Floating Buttons
                const FloatingButtonsMarkerMapScreen(),
              ],
            ),
    ));
  }
}
