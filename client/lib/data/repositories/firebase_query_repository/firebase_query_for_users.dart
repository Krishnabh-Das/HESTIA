import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/data/repositories/firebase_queries_for_markers/firebase_queries_for_markers.dart';
import 'package:intl/intl.dart';

class FirebaseQueryForUsers {
  FirebaseStorage storage = FirebaseStorage.instance;

  // -- Upload Image in Firebase Storage & get URL
  Future<String> uploadImageToMarkerImages(File image, int imageName) async {
    try {
      final userFireStoreReference =
          storage.ref().child("MarkerImages/$imageName");

      final UploadTask uploadTask = userFireStoreReference.putFile(image);

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      // URL of the image
      String imageUrl = await userFireStoreReference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print("Image Upload Error: $error");
      rethrow;
    }
  }

  // -- Delete Image From Firebase Storage
  Future<void> deleteImageFromFirebaseStorage(String filePath) async {
    try {
      // Delete the file from Firebase Storage
      await FirebaseStorage.instance.ref().child(filePath).delete();

      print('Image deleted successfully');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  // -- Add Marker Details in FireStore
  Future<void> addMarkerToUser(double lat, double long, File image,
      String description, int randomMarkerID) async {
    String? userId = AuthRepository().getUserId();

    // After getting uid do the Write Operation
    try {
      String imageUrl = await uploadImageToMarkerImages(image, randomMarkerID);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('hh:mm a, EEE, MM/yyyy').format(now);

      Map<String, dynamic> json = {
        'id': randomMarkerID,
        'lat': lat,
        'long': long,
        'formattedTime': formattedTime,
        'imageUrl': imageUrl,
        'description': description,
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Markers')
          .add(json);

      // Sequencial Trigger of Functions (After User Adding the details in Markers)
      await FirebaseQueryForMarkers().addMarkerToMarkers(json, userId);
      print('Marker added successfully in Users!');
    } catch (error) {
      print('Error adding marker in Users: $error');
    }
  }

  // -- Delete Marker Details from FireStore
  Future<void> deleteMarkerFromFirestoreUsers(int markerId) async {
    try {
      String? userId = AuthRepository().getUserId();

      // Checking if user is signed in
      if (userId == null) {
        print('User is not signed in.');
        return;
      }

      // Reference to the 'markers' collection
      CollectionReference markers = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Markers');

      // Query for the marker document with the given markerId
      QuerySnapshot snapshot =
          await markers.where('id', isEqualTo: markerId).get();

      // Check if a document was found
      if (snapshot.docs.isNotEmpty) {
        // Delete the document
        await markers.doc(snapshot.docs.first.id).delete();
        await FirebaseQueryForMarkers()
            .deleteMarkerFromFirestoreMarkers(markerId);
        print('Marker document deleted successfully');
      } else {
        print('Marker document not found in Firestore');
      }
    } catch (e) {
      print('Error deleting marker document: $e');
    }
  }

  // Retrieve Marker details from Firestore (as List of Map)
  Future<List<Map<String, dynamic>>> getMarkersFromUsers() async {
    String? userId = AuthRepository().getUserId();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Markers')
          .get();

      List<Map<String, dynamic>> markers = [];
      for (var doc in snapshot.docs) {
        markers.add(doc.data());
      }

      return markers;
    } catch (error) {
      print('Error getting markers: $error');
      return [];
    }
  }
}
