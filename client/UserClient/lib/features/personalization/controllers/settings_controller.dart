import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/data/repositories/firebase_query_for_profile/firebase_query_for_profile.dart';
import 'package:hestia/data/repositories/firebase_query_repository/firebase_query_for_users.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/indivitual_user_post.dart';
import 'package:path_provider/path_provider.dart';

class settingsController extends GetxController {
  static settingsController get instance => Get.find();

  Rx<bool> isPostSelected = true.obs;

  RxList<dynamic> settingsUserPostDetails = <dynamic>[].obs;
  RxList<dynamic> settingsUserPostDetailsWithWidget = <dynamic>[].obs;

  Rx<int> totalPost = 0.obs;

  final Rx<File?> profileImage = Rx<File?>(null);

  Rx<String> name = "Unknown User".obs;
  Rx<String> dob = "No DOB".obs;

  // -----------------------   FUNCTIONS   --------------------------
  Future<void> getSettingsUserPostData() async {
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

      Map userPostData = {
        "image": image,
        "desc": description,
        "address": marker["address"]
      };

      settingsUserPostDetails.value.add(userPostData);

      settingsUserPostDetailsWithWidget.value.add(
        Column(
          children: [
            IndivitualUserPost(
              image: image,
              description: description,
              address: marker["address"],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      );
    }
  }

  Future<void> getSettingsUserProfileDetails() async {
    Map<String, dynamic> profileDetails =
        await FirebaseQueryForUsers().getProfileFromUsers();

    debugPrint(
        "Name & DOB: ${profileDetails["name"]}, ${profileDetails["dob"]}");

    name.value = profileDetails["name"];
    dob.value = profileDetails["dob"];
    update();
  }

  Future<void> getTotalPost() async {
    String? userId = AuthRepository().getUserId();

    print("User Id Total Post: $userId");

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

  Future<File?> getProfileImageFromBackend() async {
    var auth = AuthRepository().auth;
    String email = auth.currentUser!.email!;

    try {
      Directory tempDir = await getTemporaryDirectory();

      String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
      Directory(appDirPath).createSync(recursive: true);

      File imageFile = File('$appDirPath/image_file$email.png');

      if (imageFile.existsSync()) {
        print("image exists in cache");
      } else {
        print("image exists doesn't in cache");
      }

      File? image = imageFile.existsSync()
          ? imageFile
          : await getImageFromProfile(auth.currentUser!.uid, email);

      debugPrint('Image added to cache:');

      return image;
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return File("");
    }
  }

  Future<File?> getImageFromProfile(String userId, String email) async {
    try {
      String imageUrl = "";
      final userRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Profile');

      final snapshot = await userRef.get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> existingData =
              doc.data() as Map<String, dynamic>;

          imageUrl = existingData['imageURL'];
        }

        return await MarkerMapController.instance.getImageFile(imageUrl, email);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Profile Image Get Error: $e");
      return null;
    }
  }

  Future<void> updateNameInProfile(String nameValue) async {
    await firebaseQueryForProfile()
        .updateProfileFieldsInProfile("name", nameValue);
    name.value = nameValue;
    update();
  }

  Future<void> updateDOBInProfile(String DOBValue) async {
    await firebaseQueryForProfile()
        .updateProfileFieldsInProfile("dob", DOBValue);
    dob.value = DOBValue;
    update();
  }
}
