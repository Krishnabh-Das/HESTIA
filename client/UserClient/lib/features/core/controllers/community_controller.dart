import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();

  Rx<bool> communityIsLoading = false.obs;
  RxList<dynamic> listOfCommunityPost = RxList<dynamic>();
  FirebaseStorage storage = FirebaseStorage.instance;
  Rx<bool> isCommunityPostDataLoaded = false.obs;
  static int loadMorelimit = 2;
  late Timestamp oldestDateTime;

  Future<void> uploadImageToCommunityImages(
      File image, File compressedImage, File profile, int imageName) async {
    try {
      final userFireStoreReferenceHD =
          storage.ref().child("CommunityImages/HD/U$imageName");

      final userFireStoreReferenceCompressed =
          storage.ref().child("CommunityImages/Compressed/U$imageName");

      final userFireStoreReferenceProfile =
          storage.ref().child("CommunityImages/Profile/U$imageName");

      final UploadTask uploadTask1 = userFireStoreReferenceHD.putFile(image);
      final UploadTask uploadTask2 =
          userFireStoreReferenceCompressed.putFile(compressedImage);
      final UploadTask uploadTask3 =
          userFireStoreReferenceProfile.putFile(profile);

      await uploadTask1
          .whenComplete(() => print('HD Image uploaded successfully'));
      await uploadTask2
          .whenComplete(() => print('Compressed Image uploaded successfully'));
      await uploadTask3.whenComplete(
          () => print('Community Profile Image uploaded successfully'));
    } catch (error) {
      print("Image Upload Error: $error");
      rethrow;
    }
  }

  Future<List<File?>> getImageFromCommunity(
      int listIndex, String postId) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String imagePath = '$tempPath/HESTIAtempImages';
      final Directory imageDir = Directory(imagePath);

      if (!imageDir.existsSync()) {
        imageDir.createSync();
      }

      Reference storageReference1 = FirebaseStorage.instance
          .ref()
          .child("CommunityImages/Compressed/$postId");
      Reference storageReference2 = FirebaseStorage.instance
          .ref()
          .child("CommunityImages/Profile/$postId");

      // Download the image data
      final List<int> imageData1 =
          (await storageReference1.getData()) as List<int>;
      // Download the profile image data
      final List<int> imageData2 =
          (await storageReference2.getData()) as List<int>;

      final String fileName1 = postId; // Specify a file name
      File imageFile1 = File(path.join(imagePath, fileName1));
      final String fileName2 = 'profile_$postId'; // Specify a file name
      File imageFile2 = File(path.join(imagePath, fileName2));
      await imageFile1
          .writeAsBytes(imageData1)
          .then((value) => print("Image File Community: $imageFile1"));
      await imageFile2
          .writeAsBytes(imageData2)
          .then((value) => print("Image File Profile Community: $imageFile2"));

      CommunityController.instance.listOfCommunityPost.value[listIndex]
          ["Generic_Post_Info"]["image"] = imageFile1;
      CommunityController.instance.listOfCommunityPost.value[listIndex]
          ["Generic_Post_Info"]["prof_image"] = imageFile2;

      return [imageFile1, imageFile2];
    } catch (e) {
      debugPrint("Error getting image from Community: $e");
      return [null];
    }
  }

  Future<void> getPostFromCommunity() async {
    debugPrint("inside getPostFromCommunity");
    final storageRef = FirebaseFirestore.instance.collection("Community");

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await storageRef
          .orderBy("Generic_Post_Info.last_interaction_time", descending: true)
          .limit(loadMorelimit)
          .get();

      var listOfCommunityPostRetrieved = querySnapshot.docs.map((doc) {
        String docId = doc.id;
        Map<String, dynamic> data = doc.data();
        data["Generic_Post_Info"]['post_id'] = docId;
        oldestDateTime = data["Generic_Post_Info"]["last_interaction_time"];
        return data;
      }).toList();

      debugPrint("Community post json: $listOfCommunityPostRetrieved");

      listOfCommunityPost.addAll(listOfCommunityPostRetrieved);
    } catch (e) {
      debugPrint("Error fetching community posts: $e");
    }
  }

  Future<void> loadMoreFromCommunity() async {
    final storageRef = FirebaseFirestore.instance.collection("Community");
    try {
      debugPrint("oldestDateTime : $oldestDateTime");
      final QuerySnapshot<Map<String, dynamic>> snapshot = await storageRef
          .where('Generic_Post_Info.last_interaction_time',
              isLessThan: oldestDateTime)
          .orderBy("Generic_Post_Info.last_interaction_time", descending: true)
          .limit(loadMorelimit)
          .get();

      loadMorelimit += loadMorelimit;

      var listOfCommunityPostRetrieved = snapshot.docs.map((doc) {
        String docId = doc.id;
        Map<String, dynamic> data = doc.data();
        data["Generic_Post_Info"]['post_id'] = docId;
        oldestDateTime = data["Generic_Post_Info"]["last_interaction_time"];
        return data;
      }).toList();

      print("Load More Community post json: $listOfCommunityPostRetrieved");

      listOfCommunityPost.addAll(listOfCommunityPostRetrieved);
    } catch (e) {
      print("Error fetching load more community posts: $e");
    }
  }

  Future<void> addOrRemoveLike(bool isAdd, String postid) async {
    var currentUserUID = AuthRepository().getUserId();
    final storageRef =
        FirebaseFirestore.instance.collection("Community").doc(postid);
    if (isAdd) {
      await storageRef.update({
        'Generic_Post_Info.likes': FieldValue.arrayUnion([currentUserUID]),
      });

      listOfCommunityPost.value
          .where((val) => val["Generic_Post_Info"]["post_id"] == postid)
          .forEach((val) {
        val["Generic_Post_Info"]["likes"].addAll([currentUserUID]);
        return;
      });
    } else {
      await storageRef.update({
        'Generic_Post_Info.likes': FieldValue.arrayRemove([currentUserUID]),
      });
      listOfCommunityPost.value
          .where((val) => val["Generic_Post_Info"]["post_id"] == postid)
          .forEach((val) {
        val["Generic_Post_Info"]["likes"].remove(currentUserUID);
        return;
      });
    }
  }
}
