import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseQueryForRegionMap {
  // -- Retrieve all the Polygon Points from Firestore
  Future<Set<Polygon>> getPolygonsFromFirestore() async {
    Set<Polygon> polygons = {};

    try {
      // Replace 'RegionMap' with your actual Firestore collection name
      final querySnapshot =
          await FirebaseFirestore.instance.collection('RegionMap').get();

      for (var documentSnapshot in querySnapshot.docs) {
        // Extract points from the document
        List<LatLng> latLngPoints = [];

        // Iterate through fields like '1', '2', '3', ...
        int pointIndex = 1;
        while (documentSnapshot.data().containsKey(pointIndex.toString())) {
          GeoPoint geoPoint =
              documentSnapshot.data()[pointIndex.toString()] as GeoPoint;
          latLngPoints.add(LatLng(geoPoint.latitude, geoPoint.longitude));
          pointIndex++;
        }

        // Create a Polygon with the LatLng points
        Polygon polygon = Polygon(
          polygonId: PolygonId(documentSnapshot.id),
          points: latLngPoints,
          geodesic: true,
          strokeWidth: 1,
          fillColor: Colors.redAccent.withOpacity(0.3),
          strokeColor: Colors.red,
        );

        // Add the Polygon to the set
        polygons.add(polygon);
      }
    } catch (e) {
      print('Error fetching polygons: $e');
    }

    return polygons;
  }
}
