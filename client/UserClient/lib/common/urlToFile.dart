import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File?> urlToFile(String url) async {
  try {
    // Send a GET request to the URL
    var response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Get the bytes of the response body
      List<int> bytes = response.bodyBytes;

      // Create a file in the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String fileName = url.split('/').last; // Extract filename from URL
      File file = File('$tempPath/$fileName');

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      return file;
    } else {
      throw Exception(
          'Failed to load Event Poster image: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint("Error in urlToFIle function: $e");
    return null;
  }
}
