import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();

  Rx<bool> communityIsLoading = false.obs;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImageToCommunityImages(File image, int imageName) async {
    try {
      final userFireStoreReference =
          storage.ref().child("CommunityImages/U$imageName");

      final UploadTask uploadTask = userFireStoreReference.putFile(image);

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      // URL of the image
      String imageUrl = await userFireStoreReference.getDownloadURL();
    } catch (error) {
      print("Image Upload Error: $error");
      rethrow;
    }
  }
}
