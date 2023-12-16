import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:intl/intl.dart';

class FirebaseQueryForUsers {
  FirebaseStorage storage = FirebaseStorage.instance;

  // -- Upload Image in Firebase Storage & get URL
  Future<String> uploadImageToMarkerImages(File image) async {
    try {
      final reference = storage
          .ref()
          .child("MarkerImages/${DateTime.now().millisecondsSinceEpoch}");
      final UploadTask uploadTask = reference.putFile(image);

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      // URL of the image
      String imageUrl = await reference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print("Image Upload Error: " + error.toString());
      throw error;
    }
  }

  // -- Add Marker Details in FireStore
  Future<void> addMarkerToUser(
      double lat, double long, File image, String description) async {
    String? userId = AuthRepository().getUserId();

    // Checking if user is signed in
    if (userId == null) {
      print('User is not signed in.');
      return;
    }

    // After getting uid do the Write Operation
    try {
      String imageUrl = await uploadImageToMarkerImages(image);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('hh:mm a, EEE, MM/yyyy').format(now);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Markers')
          .add({
        'lat': lat,
        'long': long,
        'formattedTime': formattedTime,
        'imageUrl': imageUrl,
        'description': description,
      });
      print('Marker added successfully!');
    } catch (error) {
      print('Error adding marker: $error');
    }
  }
}
