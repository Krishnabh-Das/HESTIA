import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/common/convert_assets_image_to_file.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/common/image_compress.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class AddCommunityPost extends StatefulWidget {
  const AddCommunityPost({super.key});

  @override
  State<AddCommunityPost> createState() => _AddCommunityPostState();
}

class _AddCommunityPostState extends State<AddCommunityPost> {
  TextEditingController desc = TextEditingController();
  var imageFile = null;
  var compressedImage = null;
  bool isImagePicked = false;
  bool isDonate = false;
  var communtiyController = CommunityController.instance;

  @override
  Widget build(BuildContext context) {
    final dark = MyAppHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: dark ? Colors.white : Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null) {
                    File image = File(pickedFile.path);
                    setState(() async {
                      imageFile = image;
                      compressedImage = await compress(image, 22);
                      isImagePicked = true;
                    });
                  }
                } catch (e) {}
              },
              child: isImagePicked
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                        height: 350,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyAppColors.primary.withOpacity(0.7),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 100),
                      child: Text(
                        "Click to Select the Incident Image",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
            ),
            const SizedBox(
              height: 17,
            ),

            // --Toggle Button IS DONATE
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Donation Post  ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Switch(
                      value: isDonate,
                      onChanged: (value) {
                        setState(() {
                          isDonate = value;
                        });
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            TextField(
              controller: desc,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              style: TextStyle(color: dark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: "Add Description",
                labelStyle: TextStyle(
                    color:
                        dark ? MyAppColors.darkGrey : MyAppColors.darkerGrey),
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: BorderSide(
                      color: dark ? MyAppColors.grey : Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide:
                      BorderSide(color: dark ? Colors.white : Colors.black),
                ),
                constraints: const BoxConstraints(minHeight: 14.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => ElevatedButton(
                child: communtiyController.communityIsLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 4,
                      )
                    : const Text("Post"),
                onPressed: () async {
                  int randomMarkerID = DateTime.now().millisecondsSinceEpoch;
                  Timestamp time = Timestamp.now();

                  String? userId = AuthRepository().getUserId();

                  // After getting uid do the Write Operation
                  try {
                    communtiyController.communityIsLoading.value = true;

                    DateTime now = DateTime.now();

                    // String formattedTime =
                    //     DateFormat('hh:mm a, EEE, MM/yyyy').format(now);

                    dynamic nonFileProfileImage =
                        settingsController.instance.profileImage.value ??
                            await getImageFile(
                                MyAppImages.profile2, "P$randomMarkerID");

                    File profImage = await compress(nonFileProfileImage, 5);

                    print("Profile Image compr: $profImage");

                    await communtiyController.uploadImageToCommunityImages(
                        imageFile, compressedImage, profImage, randomMarkerID);

                    Map<String, dynamic> genericPostInfoJson = {
                      'userID': AuthRepository().getUserId(),
                      'userName': settingsController.instance.name.value,
                      'time': time,
                      'desc': desc.text,
                      "current_address": HomeStatsRatingController
                          .instance.currentAddress.value,
                      'likes': [],
                      'total_shares': 0,
                      'isDonate': isDonate,
                      'total_comments': 0,
                      "last_interaction_time": time,
                      "isNGOPost": false,
                    };

                    Map<String, dynamic> communityPostJson = {
                      "Generic_Post_Info": genericPostInfoJson,
                      "Comments": {}
                    };

                    await FirebaseFirestore.instance
                        .collection('Community')
                        .doc("U$randomMarkerID")
                        .set(communityPostJson, SetOptions(merge: true));

                    communtiyController.communityIsLoading.value = false;

                    communityPostJson["Generic_Post_Info"]["post_id"] =
                        "U$randomMarkerID";
                    communityPostJson["Generic_Post_Info"]["image"] = imageFile;
                    communityPostJson["Generic_Post_Info"]["prof_image"] =
                        profImage;

                    communtiyController.listOfCommunityPost
                        .insert(0, communityPostJson);

                    showCustomToast(context,
                        color: Colors.green.shade400,
                        text: "Post Uploaded Successfully",
                        icon: Iconsax.tick_circle,
                        duration: 2000);

                    Navigator.pop(context);

                    print("Added $genericPostInfoJson in Community collection");

                    print('Marker added successfully in Community!');
                  } catch (error) {
                    print('Error adding marker in Community: $error');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
