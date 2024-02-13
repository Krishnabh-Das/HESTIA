// -- Get Image From URL (Use to get the firebase Storage Images)
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File> getImageFile(String assetImagePath, dynamic id) async {
  // Load the image asset as byte data
  ByteData data = await rootBundle.load(assetImagePath);
  Uint8List bytes = data.buffer.asUint8List();

  // Get the app's temporary directory
  Directory tempDir = await getTemporaryDirectory();

  // Create the necessary directories
  String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
  Directory(appDirPath).createSync(recursive: true);

  // Create a temporary file in the app's temporary directory
  File imageFile = File('$appDirPath/image_file$id.png');

  // Write the bytes to the file
  await imageFile.writeAsBytes(bytes);

  return imageFile;
}
