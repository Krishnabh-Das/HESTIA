import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseQueryForRegionMap {
  Future<Set<Polygon>> getPolygonsFromFirestore() async {
    Set<Polygon> polygons = {};

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('RegionMap').get();

      print("Query length: ${querySnapshot.docs.length}");

      for (var documentSnapshot in querySnapshot.docs) {
        List<dynamic>? arrayOfGeopoints = documentSnapshot.data()["coords"];
        print("Array of Geopoints: $arrayOfGeopoints");

        // Convert GeoPoint list to LatLng list
        List<LatLng> latlngPoints = arrayOfGeopoints!
            .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
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
      }
    } catch (e) {
      print('Error fetching Region Map: $e');
    }

    return polygons;
  }
}
