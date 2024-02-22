import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/controllers/sos_mini_map_controller.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class CustomMapSelectDialog extends StatelessWidget {
  CustomMapSelectDialog({super.key, required this.sosMiniMapController}) {
    _initData();
  }

  Future<void> _initData() async {
    sosMiniMapController.addCurrMarkerInMiniMap();
  }

  final SOSMiniMapController sosMiniMapController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                    onPressed: () {
                      SOSMiniMapController.instance.markers.assignAll({});
                      Navigator.of(context).pop();
                    },
                    icon: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        )))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Place the Marker",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Image(
                        image: AssetImage(MyAppImages.markerImage),
                        fit: BoxFit.fitHeight,
                        height: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Obx(
                        () => MarkerMapController.instance.currPos.value == null
                            ? const Center(
                                child: Text("Loading..."),
                              )
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: MarkerMapController
                                      .instance.currPos.value!,
                                  zoom: 16,
                                ),
                                onTap: (position) {
                                  sosMiniMapController.tappedPosition =
                                      position;
                                  sosMiniMapController
                                      .miniMapTapMarker(position);
                                },
                                // ignore: invalid_use_of_protected_member
                                markers: sosMiniMapController.markers.value,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            SOSMiniMapController.instance.markers.assignAll({});
                            Navigator.of(context).pop();
                          },
                          child: const Text("Mark")))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
