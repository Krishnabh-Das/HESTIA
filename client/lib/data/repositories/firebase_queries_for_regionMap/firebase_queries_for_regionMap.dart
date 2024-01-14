import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseQueryForRegionMap {
  // -- Retrieve all the Polygon Points from Firestore
  Future<Set<Polygon>> getPolygonsFromFirestore() async {
    Set<Polygon> polygons = {};

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('RegionMap').get();

      for (var documentSnapshot in querySnapshot.docs) {
        // Extract 'coords' field from Firestore document
        List<dynamic>? array_of_geopoints = documentSnapshot.data()["coords"];

        if (array_of_geopoints != null && array_of_geopoints.length > 2) {
          // Check if the 'coords' list contains valid GeoPoint objects
          if (array_of_geopoints.every((element) => element is GeoPoint)) {
            // Convert dynamic list to List<GeoPoint>
            List<GeoPoint> geoPoints = List<GeoPoint>.from(array_of_geopoints);

            // Convert GeoPoint list to LatLng list
            List<LatLng> latlngPoints = geoPoints
                .map(
                    (geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
                .toList();

            // Create a Polygon with the LatLng points
            Polygon polygon = Polygon(
              polygonId: PolygonId(documentSnapshot.id),
              points: latlngPoints,
              geodesic: true,
              strokeWidth: 1,
              fillColor: Colors.redAccent.withOpacity(0.3),
              strokeColor: Colors.red,
            );

            polygons.add(polygon);
          } else {
            print(
                "Error: 'coords' contains invalid GeoPoint objects for document ID ${documentSnapshot.id}");
          }
        } else {
          // Handle the case where 'coords' is null or missing
          print(
              "Error: 'coords' is null or missing for document ID ${documentSnapshot.id}");
        }
      }
    } catch (e) {
      print('Error fetching Region Map: $e');
    }

    return polygons;
  }
}
