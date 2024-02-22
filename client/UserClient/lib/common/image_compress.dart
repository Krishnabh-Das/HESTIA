import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Future<File> compress(File? image, int quality) async {
  try {
    debugPrint("Inside Compressed Image");

    // Read the image file
    List<int> imageBytes = await image!.readAsBytes();
    img.Image originalImage = img.decodeImage(Uint8List.fromList(imageBytes))!;

    // Compress the image with a specific quality (60 in this case)
    List<int> compressedBytes = img.encodeJpg(originalImage, quality: quality);

    // Write the compressed bytes to a new file
    File compressedFile = File('${image.path}compressed.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    printImageSize(image);
    printImageSize(compressedFile);

    return compressedFile;
  } catch (e) {
    debugPrint("Compression Error: $e");
    // Return the original file in case of an error
    return image!;
  }
}

void printImageSize(File imageFile) {
  try {
    if (imageFile.existsSync()) {
      int fileSizeInBytes = imageFile.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024;
      double fileSizeInMB = fileSizeInKB / 1024;

      debugPrint(
          'Image Size: $fileSizeInBytes bytes ($fileSizeInKB KB, $fileSizeInMB MB)');
    } else {
      debugPrint('File not found: ${imageFile.path}');
    }
  } catch (e) {
    debugPrint('Error getting image size: $e');
  }
}
