import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/common/time_format.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseQueryForSOS {
  Future<String> uploadImgToStorage(String childName, File file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveData(
      {required String incidentDescription,
      String? incidentAddress,
      required LatLng position,
      required DateTime incidentTime,
      required String incidentCategory,
      required isResolved,
      File? incidentImage,
      String? senderID}) async {
    try {
      String imageUrl = "";
      String address = "";
      String imageID = "${DateTime.now().millisecondsSinceEpoch}";

      if (incidentImage != null) {
        imageUrl = await uploadImgToStorage(
          "SOS/${FirebaseAuth.instance.currentUser!.email}-$imageID",
          incidentImage,
        );
      }

      if (incidentAddress != null) {
        address = incidentAddress;
      }

      GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);

      CollectionReference sosReportsCollection =
          _firestore.collection("SOS_Reports");

      String incidentFormattedTime = formatTimestamp(Timestamp.now());

      DocumentReference documentReference = await sosReportsCollection.add({
        "incidentDescription": incidentDescription,
        "incidentAddress": incidentAddress ?? "",
        "incidentPosition": geoPoint,
        "incidentTime": incidentTime,
        "incidentCategory": incidentCategory,
        "incidentImageLink": imageUrl,
        "senderID": senderID,
        "incidentFormattedTime": incidentFormattedTime,
        "IsResolved": isResolved
      });
      print("Report Submitted");
    } catch (err) {
      print("Error in SOS: ${err.toString()}");
    }
  }
}
