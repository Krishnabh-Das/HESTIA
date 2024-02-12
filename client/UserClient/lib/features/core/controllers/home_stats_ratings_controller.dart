import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeStatsRatingController extends GetxController {
  static HomeStatsRatingController get instance => Get.find();

  Rx<String> currentAddress = "".obs;

  Rx<double> homelessSightingsRate = 0.0.obs;
  Rx<double> crimeRate = 0.0.obs;
  Rx<double> eventsOrganizedRate = 0.0.obs;

  Rx<int> homelessSightingsNumber = 0.obs;
  Rx<int> crimeNumber = 0.obs;
  Rx<int> eventsOrganizedNumber = 0.obs;

  RxInt crimeClusterId = (-2).obs;
  RxInt homelessSightingsClusterId = (-2).obs;
  RxInt eventOrganizedClusterId = (-2).obs;

  RxList crimeMarkerMapList = [].obs;
  RxList homelessSightingsMarkerMapList = [].obs;
  RxList eventsOrganizedMarkerMapList = [].obs;

  Future<void> getHomelessSightingsRate(double? lat, double? long) async {
    try {
      var url = Uri.https(
          "hestiabackend-vu6qon67ia-el.a.run.app", "/viz/getStatsByCoord");

      print("Homeless Sightings lat: $lat, long: $long");
      var payload = {"lat": lat ?? 0, "lon": long ?? 0};

      var body = json.encode(payload);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print("Response Body: $jsonResponse");
        print(
            "Updated the Homeless Sightings Rate ${jsonResponse["marker_star"]}");

        // Stats Rate
        homelessSightingsRate.value = jsonResponse["marker_star"];
        crimeRate.value = jsonResponse["SOS_Reports_star"];

        // Stats Number
        homelessSightingsNumber.value = jsonResponse["marker_count"];
        crimeNumber.value = jsonResponse["SOS_Reports_count"];
        debugPrint("Stats Number: ${homelessSightingsNumber.value}");

        debugPrint(
            "jsonResponse[Marker_cluster]: ${jsonResponse["Marker_cluster"]}");
        debugPrint("jsonResponse[SOS_cluster]: ${jsonResponse["SOS_cluster"]}");

        // Cluster ID
        crimeClusterId.value = jsonResponse["SOS_cluster"];
        homelessSightingsClusterId.value = jsonResponse["Marker_cluster"];

        debugPrint("CLuster Id: $homelessSightingsClusterId");
      } else {
        debugPrint("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error in getting Rates for Homeless Sightings $e");
    }
  }

  Future<void> crimeIncidentsMarker() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String imagePath = '$tempPath/HESTIAtempImages';
      final Directory imageDir = Directory(imagePath);
      if (!imageDir.existsSync()) {
        imageDir.createSync();
      }

      // Reference to the 'Markers' collection
      CollectionReference sosCollection =
          FirebaseFirestore.instance.collection('SOS_Reports');

      debugPrint("Cluster ID: ${crimeClusterId.value}");

      // Query documents where the 'cluster_id' field is equal to 2
      QuerySnapshot querySnapshot = await sosCollection
          .where('cluster', isEqualTo: crimeClusterId.value)
          .get();

      // Loop through the documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Access the document data
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        Reference storageReference =
            FirebaseStorage.instance.ref().child("MarkerImages/${data["id"]}");

        // Download the image data
        final List<int> imageData =
            (await storageReference.getData()) as List<int>;

        final String fileName = '${data["id"]}.jpg'; // Specify a file name
        File imageFile = File(path.join(imagePath, fileName));
        await imageFile
            .writeAsBytes(imageData)
            .then((value) => debugPrint("Image File crime: $imageFile"));

        HomeStatsRatingController.instance.crimeMarkerMapList.add({
          "time": data["formattedTime"],
          "address": data["address"],
          "desc": data["description"],
          "image": imageFile
        });

        // Print or use the document data as needed
        debugPrint('Document ID: ${document.id}, Data: $data');
      }
    } catch (e) {
      debugPrint('Error querying Firestore: $e');
    }
  }

  Future<void> homelessSightingsMarker() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String imagePath = '$tempPath/HESTIAtempImages';
      final Directory imageDir = Directory(imagePath);
      if (!imageDir.existsSync()) {
        imageDir.createSync();
      }

      // Reference to the 'Markers' collection
      CollectionReference markersCollection =
          FirebaseFirestore.instance.collection('Markers');

      debugPrint("Homeless Sightings ID: ${homelessSightingsClusterId.value}");

      // Query documents where the 'cluster_id' field is equal to 2
      QuerySnapshot querySnapshot = await markersCollection
          .where('cluster', isEqualTo: homelessSightingsClusterId?.value)
          .get();

      // Loop through the documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Access the document data
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        Reference storageReference =
            FirebaseStorage.instance.ref().child("MarkerImages/${data["id"]}");

        // Download the image data
        final List<int> imageData =
            (await storageReference.getData()) as List<int>;

        final String fileName = '${data["id"]}.jpg'; // Specify a file name
        File imageFile = File(path.join(imagePath, fileName));
        await imageFile.writeAsBytes(imageData).then(
            (value) => debugPrint("Image File Homeless Sightings: $imageFile"));

        HomeStatsRatingController.instance.homelessSightingsMarkerMapList.add({
          "time": data["formattedTime"],
          "address": data["address"],
          "desc": data["description"],
          "image": imageFile
        });

        // Print or use the document data as needed
        debugPrint('Document ID: ${document.id}, Data: $data');
      }
    } catch (e) {
      debugPrint('Error querying Firestore: $e');
    }
  }
}
