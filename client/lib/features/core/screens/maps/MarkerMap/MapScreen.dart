import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/Floating_Buttons_Mark_map_Screen.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/widgets/search_bar.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
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

    markerMapController.searchController.addListener(() {
      markerMapController.onChange(uuid);
    });
    await markerMapController.makeMarkersFromJson();
    await settingsController.instance
        .getProfileImageFromBackend()
        .then((value) {
      markerMapController.isProfileImageLoaded.value = true;

      settingsController.instance.profileImage.value = value;
    });
    await markerMapController.createAndAddCurrMarker();
  }

  @override
  Widget build(BuildContext context) {
    markerMapController.context = context;

    return Scaffold(
        body: Obx(
      () => (markerMapController.currPos.value == null &&
              !markerMapController.isProfileImageLoaded.value)
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: <Widget>[
                // -- Google Map
                Obx(
                  () => GoogleMap(
                    onMapCreated: (controller) async {
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
                        markerMapController.addTapMarkers(latLng, "tap Marker");
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
                      child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          heroTag: "Search FAB",
                          shape: CircleBorder(eccentricity: 0),
                          child: Icon(
                            Iconsax.search_normal,
                            color: Colors.white,
                          ),
                          onPressed: () => markerMapController
                              .isSearchBarVisible.value = true)),
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
