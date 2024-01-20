import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';

class FirebaseQueryForMarkers {
  Future<void> addMarkerToMarkers(
      Map<String, dynamic> json, String? userid) async {
    if (userid != null) {
      json.addAll({
        "userid": userid,
      });

      await FirebaseFirestore.instance
          .collection('Markers')
          .doc(json["id"])
          .set(json);
      print('Marker added successfully in Markers!');
    } else {
      print("User ID is null");
    }
  }

  Future<List<Map<String, dynamic>>> getMarkersFromMarkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Markers').get();
      print("Markers retrieved from Markers");

      return snapshot.docs
          .map((doc) => doc.data())
          .toList(); // List of all the Json
    } catch (error) {
      print('Error getting markers: $error');
      return [];
    }
  }

  Future<void> deleteMarkerFromFirestoreMarkers(int markerId) async {
    try {
      String? userId = AuthRepository().getUserId();

      // Checking if user is signed in
      if (userId == null) {
        print('User is not signed in.');
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
        print('Marker document deleted successfully');
      } else {
        print('Marker document not found in Firestore');
      }
    } catch (e) {
      print('Error deleting marker document: $e');
    }
  }
}
