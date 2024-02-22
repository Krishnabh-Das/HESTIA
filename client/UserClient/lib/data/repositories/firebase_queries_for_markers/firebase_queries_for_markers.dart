import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';

class FirebaseQueryForMarkers {
  Future<void> addMarkerToMarkers(
      Map<String, dynamic> json, String? userid, int markerId) async {
    if (userid != null) {
      json.addAll({
        "userid": userid,
      });

      await FirebaseFirestore.instance
          .collection('Markers')
          .doc("$markerId")
          .set(json);
      debugPrint('Marker added successfully in Markers!');
    } else {
      debugPrint("User ID is null");
    }
  }

  Future<List<Map<String, dynamic>>> getMarkersFromMarkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Markers').get();
      debugPrint("Markers retrieved from Markers");

      return snapshot.docs
          .map((doc) => doc.data())
          .toList(); // List of all the Json
    } catch (error) {
      debugPrint('Error getting markers: $error');
      return [];
    }
  }

  Future<void> deleteMarkerFromFirestoreMarkers(int markerId) async {
    try {
      String? userId = AuthRepository().getUserId();

      // Checking if user is signed in
      if (userId == null) {
        debugPrint('User is not signed in.');
        return;
      }

      // Reference to the 'markers' collection
      CollectionReference markers =
          FirebaseFirestore.instance.collection('Markers');

      // Query for the marker document with the given markerId
      QuerySnapshot snapshot =
          await markers.where('id', isEqualTo: markerId).get();

      // Check if a document was found
      if (snapshot.docs.isNotEmpty) {
        // Delete the document
        await markers.doc(snapshot.docs.first.id).delete();
        debugPrint('Marker document deleted successfully');
      } else {
        debugPrint('Marker document not found in Firestore');
      }
    } catch (e) {
      debugPrint('Error deleting marker document: $e');
    }
  }
}
