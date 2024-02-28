import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
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

  RxBool hasCrimeIncidentsJSONReceived = false.obs;
  RxBool volunteerUploadLoad = false.obs;

  // Event's Post list
  RxList eventsPostList = [].obs;

  Future<void> getHomelessSightingsRate(double? lat, double? long) async {
    try {
      var url = Uri.https(
          "hestiabackend-vu6qon67ia-el.a.run.app", "/viz/getStatsByCoord");

      debugPrint("Homeless Sightings lat: $lat, long: $long");
      var payload = {"lat": lat ?? 0, "lon": long ?? 0};

      var body = json.encode(payload);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("Response Body: $jsonResponse");
        debugPrint(
            "Updated the Homeless Sightings Rate ${jsonResponse["marker_star"]}");

        // Stats Number
        homelessSightingsNumber.value = jsonResponse["marker_count"];
        crimeNumber.value = jsonResponse["SOS_Reports_count"];
        eventsOrganizedNumber.value = jsonResponse["Events_Reports_count"];
        debugPrint("Stats Number: ${homelessSightingsNumber.value}");

        debugPrint(
            "jsonResponse[Marker_cluster]: ${jsonResponse["Marker_cluster"]}");
        debugPrint("jsonResponse[SOS_cluster]: ${jsonResponse["SOS_cluster"]}");

        // Cluster ID
        crimeClusterId.value = jsonResponse["SOS_cluster"];
        homelessSightingsClusterId.value = jsonResponse["Marker_cluster"];
        eventOrganizedClusterId.value = jsonResponse["Events_cluster"];
        HomeStatsRatingController.instance.hasCrimeIncidentsJSONReceived.value =
            true;
        // Stats Rate
        homelessSightingsRate.value = jsonResponse["marker_star"];
        crimeRate.value = jsonResponse["SOS_Reports_star"];
        eventsOrganizedRate.value = jsonResponse["SOS_Reports_star"];
        debugPrint("CLuster Id: $homelessSightingsClusterId");
      } else {
        HomeStatsRatingController.instance.hasCrimeIncidentsJSONReceived.value =
            true;
        debugPrint("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      HomeStatsRatingController.instance.hasCrimeIncidentsJSONReceived.value =
          true;
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
      var sosCollection = FirebaseFirestore.instance.collection('SOS_Reports');

      debugPrint("Cluster ID: ${crimeClusterId.value}");

      // Query documents where the 'cluster_id' field is equal to 2
      var querySnapshot = await sosCollection
          .where('cluster', isEqualTo: crimeClusterId.value)
          .get();

      debugPrint("querySnapshot docs: ${querySnapshot.docs.length}");

      // Loop through the documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Access the document data
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        debugPrint("Crime Incidents JSON data: $data");

        var response = await http.get(Uri.parse(data["incidentImageLink"]));
        final String fileName = '${document.id}';
        File imageFile = File(path.join(imagePath, fileName));
        await imageFile.writeAsBytes(response.bodyBytes);

        HomeStatsRatingController.instance.crimeMarkerMapList.add({
          "time": data["incidentFormattedTime"] ?? data["formattedTime"],
          "address": data["incidentAddress"],
          "desc": data["incidentDescription"],
          "image": imageFile
        });
      }
      debugPrint(
          'Crime Incident Map List: ${HomeStatsRatingController.instance.crimeMarkerMapList}');
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
          .where('cluster', isEqualTo: homelessSightingsClusterId.value)
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

  Future<void> getEventsPost() async {
    debugPrint("inside getEvnetsPost");
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Events').get();

      // Iterate through each document in the query snapshot
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Get all fields from the document data
        var data = documentSnapshot.data() as Map<String, dynamic>;

        // Remove the "volunteers" field if it exists
        if (data.containsKey('volunteers')) {
          data.remove('volunteers');
        }

        data["eventId"] = documentSnapshot.id;

        eventsPostList.add(data);
      }
    } catch (e) {
      debugPrint('Error fetching data from Firestore: $e');
    }
  }

  // -- Upload the volunteer's image in storage
  Future<String> volunteerImageUploadAndGetUrl(
      File volunteerImageFile, String eventId) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String imagePath = '$tempPath/HESTIAtempImages/Events';
      final Directory imageDir = Directory(imagePath);

      if (!imageDir.existsSync()) {
        imageDir.createSync();
      }

      img.Image image = img.decodeImage(volunteerImageFile.readAsBytesSync())!;
      List<int> pngBytes = img.encodePng(image);

      // Create a temporary File with PNG format
      File pngFile =
          File('$imagePath/volunteerImage.png'); // Specify the file name here
      await pngFile.writeAsBytes(pngBytes);

      Reference storageReference = FirebaseStorage.instance.ref().child(
          'Event/$eventId/Volunteer/${AuthRepository().getUserId()}/volunteerImage');
      UploadTask uploadTask = storageReference.putFile(pngFile);
      await uploadTask.whenComplete(
          () => debugPrint('Volunteer Image uploaded to Firebase Storage'));
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      debugPrint("volunteerImageUploadAndGetUrl error: $e");
      return "";
    }
  }

  // -- Upload the id Proof image in storage
  Future<String> idProofImageUploadAndGetUrl(
      File idProofImageFile, String eventId) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String imagePath = '$tempPath/HESTIAtempImages/Events';
      final Directory imageDir = Directory(imagePath);

      // Ensure that the directory exists
      if (!imageDir.existsSync()) {
        imageDir.createSync(
            recursive:
                true); // Create directory and its parent directories if they don't exist
      }

      img.Image image = img.decodeImage(idProofImageFile.readAsBytesSync())!;
      List<int> pngBytes = img.encodePng(image);

      // Create a temporary File with PNG format
      File pngFile =
          File('$imagePath/idProof.png'); // Specify the file name here
      await pngFile.writeAsBytes(pngBytes);

      Reference storageReference = FirebaseStorage.instance.ref().child(
          'Event/$eventId/Volunteer/${AuthRepository().getUserId()}/idProof');
      UploadTask uploadTask = storageReference.putFile(pngFile);
      await uploadTask.whenComplete(
          () => debugPrint('ID Proof Image uploaded to Firebase Storage'));
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      debugPrint("idProofImageUploadAndGetUrl error: $e");
      return "";
    }
  }

  // -- Upload the volunteer's json in firestore
  Future<void> uploadEventsVolunteerJSON(
      Map<String?, dynamic> jsonData, String eventId) async {
    try {
      // Get a reference to the Firestore document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Events').doc(eventId);

      // Update the document by adding the JSON map to the 'volunteers' array
      await documentReference.update({
        'volunteers': FieldValue.arrayUnion([jsonData])
      });

      debugPrint('JSON data added to Firestore Events Volunteer successfully');
    } catch (e) {
      debugPrint('Error adding JSON data to Firestore: $e');
    }
  }
}
