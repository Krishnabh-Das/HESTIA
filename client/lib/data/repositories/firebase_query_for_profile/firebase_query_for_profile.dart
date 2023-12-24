import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:path_provider/path_provider.dart';

class firebaseQueryForProfile {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImageToBackend(File image) async {
    var _auth = AuthRepository().auth;
    if (_auth == null) {
      return;
    }

    try {
      // -- Upload Image in Cache
      await addImageInCache(image, _auth.currentUser!.email!);

      // -- Upload Image in Storage
      final userFireStoreReference =
          storage.ref().child("ProfileImages/${_auth.currentUser!.email}");

      final UploadTask uploadTask = userFireStoreReference.putFile(image);

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      String imageUrl = await userFireStoreReference.getDownloadURL();

      String? userId = AuthRepository().getUserId();

      // -- Upload Image url in Firestore
      await uploadImageinProfile(userId, imageUrl);
    } catch (error) {
      print("Image Upload Error: $error");
      rethrow;
    }
  }

  Future<void> uploadImageinProfile(String? userId, String imageUrl) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Profile');

      final snapshot =
          await userRef.get(); // Get all documents in the collection

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> existingData =
              doc.data() as Map<String, dynamic>;

          // Add or update the 'imageURL' field
          existingData['imageURL'] = imageUrl;

          // Set the updated data back to the document without overwriting other fields
          await userRef.doc(doc.id).set(existingData, SetOptions(merge: true));
        }
      } else {
        await userRef.add({"imageURL": imageUrl});
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  Future<void> addImageInCache(File image, String email) async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      String appDirPath = '${tempDir.path}/HESTIA/MarkerImages/';
      Directory(appDirPath).createSync(recursive: true);

      File imageFile = File('$appDirPath/image_file${email}.png');

      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }

      image.copySync(imageFile.path);

      print('Image added to cache: ${imageFile.path}');
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  Future<void> updateProfileFieldsInProfile(
      String type, String fieldValue) async {
    var _auth = AuthRepository().auth;
    if (_auth == null) {
      return;
    }
    var userId = _auth.currentUser!.uid;

    try {
      final userRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Profile');
      final snapshot = await userRef.get();

      if (snapshot.docs.isNotEmpty) {
        // Document exists, update the field
        for (var doc in snapshot.docs) {
          Map<String, dynamic> existingData =
              doc.data() as Map<String, dynamic>;
          existingData[type] = fieldValue;
          await userRef.doc(doc.id).set(existingData, SetOptions(merge: true));
        }
      } else {
        // Document doesn't exist, create a new one
        await userRef.add({type: fieldValue});
      }
    } catch (e) {
      print("updateProfileFieldsInProfile error: ${e.toString()}");
    }
  }
}
