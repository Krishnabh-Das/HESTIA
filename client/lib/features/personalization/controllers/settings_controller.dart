import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/data/repositories/firebase_query_repository/firebase_query_for_users.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/screens/settings/settings_screen.dart';
import 'package:path_provider/path_provider.dart';

class settingsController extends GetxController {
  static settingsController get instance => Get.find();

  Rx<bool> isPostSelected = true.obs;
  void toggleIsPostSelected() {
    isPostSelected.value = !isPostSelected.value;
  }

  RxList<dynamic> settingsUserPostDetails = <dynamic>[].obs;

  RxMap<String, dynamic> settingUserProfileDetails = <String, dynamic>{}.obs;

  Rx<int> totalPost = 0.obs;

  // -----------------------   FUNCTIONS   --------------------------
  Future<void> getSettingsUserPostData() async {
    List<dynamic> returnList = <dynamic>[];
    final markers = await FirebaseQueryForUsers().getMarkersFromUsers();
    for (var marker in markers) {
      var imageUrl = marker["imageUrl"];

      Directory tempDir = await getTemporaryDirectory();
      String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
      File? imageFile = File('$appDirPath/image_file${marker["id"]}.png');

      File? image = imageFile.existsSync()
          ? imageFile
          : await MarkerMapController.instance
              .getImageFile(imageUrl, marker["id"]);

      String description = marker["description"];

      Map userPostData = {"image": image, "desc": description};
      returnList.add(userPostData);
    }

    settingsUserPostDetails.value = returnList;
  }

  Future<void> getSettingsUserProfileDetails() async {
    Map<String, dynamic> profileDetails =
        await FirebaseQueryForUsers().getProfileFromUsers();

    print("Name & DOB: ${profileDetails["name"]}, ${profileDetails["dob"]}");

    settingUserProfileDetails.value = profileDetails;
    update();
  }

  Future<void> getTotalPost() async {
    String? userId = AuthRepository().getUserId();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Markers')
          .get();

      totalPost.value = snapshot.size;
      print('Number of documents: ${snapshot.size}');
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }
}
