import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  int? crimeClusterId, homelessSightingsClusterId, eventOrganizedClusterId;
  RxList crimeMarkerMapList = [].obs;
  RxList homelessSightingsMarkerMapList = [].obs;
  RxList eventsOrganizedMarkerMapList = [].obs;

  Future<void> getHomelessSightingsRate(double? lat, double? long) async {
    try {
      var url = Uri.https(
          "hestiabackend-vu6qon67ia-el.a.run.app", "/viz/getStatsByCoord");

      print("Homeless Sightings lat: $lat, long: $long");
      var payload = {"lat": lat ?? 0.0, "lon": long ?? 0.0};

      var body = json.encode(payload);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(
            "Updated the Homeless Sightings Rate ${jsonResponse["marker_star"]}");
        homelessSightingsRate.value = jsonResponse["marker_star"]
            .toDouble(); // Updated the Homeless Sightings Rate
        crimeRate.value = jsonResponse["SOS_Reports_star"].toDouble();

        // Cluster ID
        homelessSightingsClusterId = jsonResponse["Marker_cluster"];
        crimeClusterId = jsonResponse["SOS_cluster"];

        print("CLuster Id: $crimeClusterId");

        // Getting the Crime Cluster Markers
        if (crimeClusterId != -2) {
          await HomeStatsRatingController.instance.crimeIncidentsMarker();
        }
        if (homelessSightingsClusterId != -2) {
          await HomeStatsRatingController.instance
              .homelessSightingsMarkerMapList();
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getting Rates for Homeless Sightings $e");
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
      CollectionReference markersCollection =
          FirebaseFirestore.instance.collection('Markers');

      print("Cluster ID: $crimeClusterId");

      // Query documents where the 'cluster_id' field is equal to 2
      QuerySnapshot querySnapshot = await markersCollection
          .where('cluster', isEqualTo: crimeClusterId)
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
            .then((value) => print("Image File crime: $imageFile"));

        HomeStatsRatingController.instance.crimeMarkerMapList.add({
          "time": data["formattedTime"],
          "address": data["address"],
          "desc": data["description"],
          "image": imageFile
        });

        // Print or use the document data as needed
        print('Document ID: ${document.id}, Data: $data');
      }
    } catch (e) {
      print('Error querying Firestore: $e');
    }
  }
}
