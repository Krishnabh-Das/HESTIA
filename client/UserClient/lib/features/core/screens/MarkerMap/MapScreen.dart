import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/MarkerMap/widgets/Floating_Buttons_Mark_map_Screen.dart';
import 'package:hestia/features/core/screens/MarkerMap/widgets/search_bar.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

import 'package:iconsax/iconsax.dart';

class MarkerMapScreen extends StatelessWidget {
  // --- MAP CONTROLLER
  final MarkerMapController markerMapController = Get.find();
  String mapTheme = "";

  MarkerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    markerMapController.context = context;

    DefaultAssetBundle.of(context)
        .loadString("assets/map_style/aubergine.json")
        .then((value) {
      mapTheme = value;
    });
    return Scaffold(
        body: Obx(
      () => (markerMapController.currPos.value == null &&
              !markerMapController.isProfileImageLoaded.value)
          ? Center(
              child: Text(
                "Loading...",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            )
          : Stack(
              children: <Widget>[
                // -- Google Map
                Obx(
                  () => GoogleMap(
                    onMapCreated: (controller) async {
                      markerMapController.googleMapController = controller;
                      if (MyAppHelperFunctions.isNightTime()) {
                        markerMapController.googleMapController
                            .setMapStyle(mapTheme);
                      }
                      markerMapController
                          .updateGoogleControllerForCustomInfoWindowController(
                              controller);
                      markerMapController.tapPosition =
                          markerMapController.currPos.value;
                    },
                    initialCameraPosition: CameraPosition(
                        target: markerMapController.currPos.value!,
                        zoom: 16,
                        tilt: 40),
                    onTap: (latLng) {
                      markerMapController
                          .customInfoWindowController.value.hideInfoWindow!();
                      if (markerMapController.IsInfoWindowOpen.value == false &&
                          !markerMapController.isSearchBarVisible.value) {
                        markerMapController.tapPosition = latLng;
                        markerMapController.addTapMarkers(
                            latLng, "tap Marker", null);
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

                // -- Floating Buttons
                const FloatingButtonsMarkerMapScreen(),

                // -- Back Button
                Positioned(
                    top: 66,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF1F616B),
                      child: Center(
                        child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_sharp,
                              size: 26,
                              color: Colors.white,
                            )),
                      ),
                    )),

                // -- Search Bar
                if (!markerMapController.isSearchBarVisible.value) ...[
                  Positioned(
                      top: 60,
                      right: 10,
                      child: FloatingActionButton(
                          backgroundColor: const Color(0xFF1F616B),
                          heroTag: "Search FAB",
                          shape: const CircleBorder(eccentricity: 0),
                          child: const Icon(
                            Iconsax.search_normal,
                            color: Colors.white,
                          ),
                          onPressed: () => markerMapController
                              .isSearchBarVisible.value = true)),
                ] else if (markerMapController.isSearchBarVisible.value) ...[
                  searchBar(markerMapController: markerMapController),
                ],

                Positioned(
                  bottom: 40,
                  left: 0.110 * MyAppHelperFunctions.screenWidth(),
                  child: Container(
                    width: MyAppHelperFunctions.screenWidth() - 80,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFF1F616B)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => MarkerMapController.instance
                                .toggleShowPolygon(),
                            icon: Icon(
                              Icons.change_circle,
                              color: Colors.white,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () => MarkerMapController.instance
                                .moveToCurrLocation(settingsController
                                    .instance.profileImage.value),
                            icon: Icon(
                              Icons.track_changes_outlined,
                              color: Colors.white,
                              size: 30,
                            )),
                        IconButton(
                          onPressed: () => showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              constraints: BoxConstraints.expand(height: 200),
                              builder: (context) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        MarkerMapController.instance
                                            .getImage(true);
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.camera,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Submit By Camera",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        MarkerMapController.instance
                                            .getImage(false);
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Iconsax.gallery,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Submit By Gallery",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                );
                              }),
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}
