import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/firebase_query_repository/firebase_query_for_users.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class AddMarkerDetailsScreen extends StatelessWidget {
  AddMarkerDetailsScreen(
      {super.key,
      required this.image,
      required this.position,
      required this.customInfoWindowController});

  TextEditingController desc = TextEditingController();
  final File image;
  LatLng position;

  final CustomInfoWindowController customInfoWindowController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            image != File('') && image.existsSync()
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: Colors.black, width: 0.9),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 15,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Image.file(
                        image,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: desc,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Add Description",
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                constraints: const BoxConstraints(minHeight: 14.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => SizedBox(
                child: ElevatedButton(
                  child: MarkerMapController.instance.isloading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 4,
                        )
                      : const Text("Post"),
                  onPressed: () async {
                    showCustomToast(context,
                        color: Colors.yellow.shade600,
                        text: "Please Wait.......",
                        icon: Icons.hourglass_empty,
                        duration: 2000);
                    MarkerMapController.instance.toggleIsLoading();
                    int randomMarkerID = DateTime.now().millisecondsSinceEpoch;
                    Timestamp time = Timestamp.now();
                    Directory tempDir = await getTemporaryDirectory();

                    // Create the necessary directories
                    String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
                    Directory(appDirPath).createSync(recursive: true);

                    // Create a destination file in the desired directory
                    File destinationFile =
                        File('$appDirPath/image_file$randomMarkerID.png');

                    // Copy the original image file to the destination file
                    image.copySync(destinationFile.path);
                    Marker marker = MarkerMapController.instance
                        .MakeFixedMarker(
                            randomMarkerID,
                            position,
                            customInfoWindowController,
                            desc.text,
                            time,
                            "",
                            true);

                    var address = await getPlacemarks(
                        position.latitude, position.longitude);

                    // Adding Marker details in Firestore
                    await FirebaseQueryForUsers()
                        .addMarkerToUser(position.latitude, position.longitude,
                            image, desc.text, randomMarkerID, time, address)
                        .then((value) =>
                            MarkerMapController.instance.toggleIsLoading())
                        .onError((error, stackTrace) {
                      MarkerMapController.instance.toggleIsLoading();
                      showCustomToast(context,
                          color: Colors.red.shade400,
                          text: "Error Uploaing Data in Database: $error",
                          icon: Icons.warning,
                          duration: 2000);
                    });

                    HalfMapController.instance.allHalfMapMarkers.add(Marker(
                        markerId: MarkerId("$randomMarkerID"),
                        position: position,
                        infoWindow: const InfoWindow(title: "Your Marker"),
                        icon: BitmapDescriptor.defaultMarker));

                    // Updating the setttings Post
                    settingsController.instance.settingsUserPostDetails.value
                        .add({
                      "image": image,
                      "desc": desc.text,
                      "address": address
                    });

                    settingsController.instance.totalPost.value =
                        ++settingsController.instance.totalPost.value;

                    showCustomToast(context,
                        color: Colors.green.shade400,
                        text: "Post Uploaded Successfully",
                        icon: Iconsax.tick_circle,
                        duration: 2000);

                    // Returing the Marker
                    Navigator.pop(context, marker);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> getPlacemarks(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      var address = '';

      if (placemarks.isNotEmpty) {
        // Concatenate non-null components of the address

        var streets = placemarks.reversed
            .map((placemark) => placemark.street)
            .where((street) => street != null);

        // Filter out unwanted parts
        streets = streets.where((street) =>
            street!.toLowerCase() !=
            placemarks.reversed.last.locality!
                .toLowerCase()); // Remove city names
        streets =
            streets.where((street) => !street!.contains('+')); // Remove codes

        address += streets.join(', ');

        address += ', ${placemarks.reversed.last.subLocality ?? ''}';
        address += ', ${placemarks.reversed.last.locality ?? ''}';
        address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.postalCode ?? ''}';
        address += ', ${placemarks.reversed.last.country ?? ''}';
      }

      return address;
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address";
    }
  }
}