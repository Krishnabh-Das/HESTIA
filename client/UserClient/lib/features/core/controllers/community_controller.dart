import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();

  Rx<bool> communityIsLoading = false.obs;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImageToCommunityImages(
      File image, File compressedImage, int imageName) async {
    try {
      final userFireStoreReferenceHD =
          storage.ref().child("CommunityImages/HD/U$imageName");

      final userFireStoreReferenceCompressed =
          storage.ref().child("CommunityImages/Compressed/U$imageName");

      final UploadTask uploadTask1 = userFireStoreReferenceHD.putFile(image);
      final UploadTask uploadTask2 =
          userFireStoreReferenceCompressed.putFile(compressedImage);

      await uploadTask1
          .whenComplete(() => print('HD Image uploaded successfully'));
      await uploadTask1
          .whenComplete(() => print('Compressed Image uploaded successfully'));
    } catch (error) {
      print("Image Upload Error: $error");
      rethrow;
    }
  }

  Future<File> compress(File image) async {
    try {
      print("Inside Compressed Image");

      // Read the image file
      List<int> imageBytes = await image.readAsBytes();
      img.Image originalImage =
          img.decodeImage(Uint8List.fromList(imageBytes))!;

      // Compress the image with a specific quality (60 in this case)
      List<int> compressedBytes = img.encodeJpg(originalImage, quality: 40);

      // Write the compressed bytes to a new file
      File compressedFile = File(image.path + 'compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      printImageSize(image);
      printImageSize(compressedFile);

      return compressedFile;
    } catch (e) {
      print("Compression Error: $e");
      // Return the original file in case of an error
      return image;
    }
  }

  void printImageSize(File imageFile) {
    try {
      if (imageFile.existsSync()) {
        int fileSizeInBytes = imageFile.lengthSync();
        double fileSizeInKB = fileSizeInBytes / 1024;
        double fileSizeInMB = fileSizeInKB / 1024;

        print(
            'Image Size: $fileSizeInBytes bytes ($fileSizeInKB KB, $fileSizeInMB MB)');
      } else {
        print('File not found: ${imageFile.path}');
      }
    } catch (e) {
      print('Error getting image size: $e');
    }
  }
}
