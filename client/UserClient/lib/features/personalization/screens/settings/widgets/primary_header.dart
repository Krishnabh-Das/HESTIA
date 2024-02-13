import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/firebase_query_for_profile/firebase_query_for_profile.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/MarkerMap/widgets/custom_marker.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';

import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/device/device_utility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class PrimaryHeader extends StatelessWidget {
  const PrimaryHeader({
    super.key,
    required this.screenWidth,
    required this.settingsController1,
  });

  final double screenWidth;
  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenWidth * 0.95,
      child: Stack(
        children: [
          // Background Circle
          Positioned(
            top: -screenWidth / 4.8,
            left: 0,
            right: 0,
            child: Container(
              height: screenWidth,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        MyAppDeviceUtils.getScreenWidth(context)),
                    bottomRight: Radius.circular(
                        MyAppDeviceUtils.getScreenWidth(context))),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(0, 7, 112, 82),
                    Color(0xFF00D47E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            left: 0,
            right: 0,
            top: -10,
            child: AppBar(
              title: const Text(
                "Settings",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              centerTitle: true,
              leading: const Icon(
                Iconsax.setting,
                color: Colors.white,
              ),
            ),
          ),

          // Name & Email
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    settingsController.instance.name.value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${FirebaseAuth.instance.currentUser?.email}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Profile Image
          Positioned(
            top: screenWidth * 0.6,
            left: MyAppDeviceUtils.getScreenWidth(context) / 2 - 48,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade300),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            settingsController1.profileImage.value != null
                                ? Image.file(
                                        settingsController1.profileImage.value!)
                                    .image
                                : const AssetImage(MyAppImages.profile2),
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
              top: screenWidth * 0.79,
              left: MyAppDeviceUtils.getScreenWidth(context) / 1.75,
              child: IconButton(
                  onPressed: () async {
                    try {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        File? image = File(pickedFile.path);

                        await firebaseQueryForProfile()
                            .uploadImageToBackend(image)
                            .onError((error, stackTrace) => showCustomToast(
                                context,
                                color: Colors.red.shade400,
                                text:
                                    "Error Uploding Image in Database: $error",
                                icon: Icons.clear_sharp,
                                duration: 2000));

                        settingsController1.profileImage.value = image;

                        addNewCustomMarkerInMapScreens(image);

                        settingsController1.update();
                        showCustomToast(context,
                            color: Colors.green.shade400,
                            text: "Profile Image Updated",
                            icon: Iconsax.tick_circle,
                            duration: 2000);
                      }
                    } catch (e) {
                      print("Error picking image: $e");
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }

  Future<File> assetToFile(String assetPath) async {
    // Load the asset as a byte data
    ByteData data = await rootBundle.load(assetPath);

    // Get a list of bytes from the byte data
    List<int> bytes = data.buffer.asUint8List();

    // Create a file in a temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}';
    File tempFile = File(tempFilePath);

    // Write the bytes to the file
    await tempFile.writeAsBytes(bytes);

    return tempFile;
  }

  Future<void> addNewCustomMarkerInMapScreens(File image) async {
    final marker = Marker(
      markerId: const MarkerId("currentLocation"),
      position: MarkerMapController.instance.currPos.value!,
      icon: await CircularWidget(
        imageFile: image,
      ).toBitmapDescriptor(
        logicalSize: const Size(50, 50),
        imageSize: const Size(175, 175),
      ),
      infoWindow: const InfoWindow(title: "Current Location"),
    );

    MarkerMapController.instance.homeMarkerAdd(marker);

    HalfMapController.instance.allHalfMapMarkers.removeWhere(
      (marker) => marker.markerId.value == "currentLocation",
    );

    HalfMapController.instance.allHalfMapMarkers.add(marker);
  }
}
