import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/common/getPlacemart.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddCommunityPost extends StatefulWidget {
  AddCommunityPost({super.key});

  @override
  State<AddCommunityPost> createState() => _AddCommunityPostState();
}

class _AddCommunityPostState extends State<AddCommunityPost> {
  TextEditingController desc = TextEditingController();
  var imageFile;
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
                    setState(() {
                      imageFile = image;
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
            SizedBox(
              height: 17,
            ),

            // --Toggle Button ISDONATE
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
            SizedBox(
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
                  communtiyController.communityIsLoading.value = true;

                  showCustomToast(context,
                      color: Colors.yellow.shade600,
                      text: "Please Wait.......",
                      icon: Icons.hourglass_empty,
                      duration: 2000);

                  int randomMarkerID = DateTime.now().millisecondsSinceEpoch;
                  Timestamp time = Timestamp.now();

                  String? userId = AuthRepository().getUserId();

                  // After getting uid do the Write Operation
                  try {
                    var compressedImage =
                        await communtiyController.compress(imageFile);

                    await communtiyController.uploadImageToCommunityImages(
                        imageFile, compressedImage, randomMarkerID);

                    DateTime now = DateTime.now();

                    // String formattedTime =
                    //     DateFormat('hh:mm a, EEE, MM/yyyy').format(now);

                    Map<String, dynamic> json = {
                      'postID': "U$randomMarkerID",
                      'userName': settingsController.instance.name.value,
                      'time': time,
                      'desc': desc.text,
                      "address": HomeStatsRatingController
                          .instance.currentAddress.value,
                      'like': 0,
                      'isDonate': isDonate,
                      'total_comments': 0,
                      "last_interaction_time": time,
                      "NGO_post": false
                    };

                    await FirebaseFirestore.instance
                        .collection('Community')
                        .doc("U$randomMarkerID")
                        .collection('Generic_Post_Info')
                        .add(json);

                    communtiyController.communityIsLoading.value = false;

                    showCustomToast(context,
                        color: Colors.green.shade400,
                        text: "Post Uploaded Successfully",
                        icon: Iconsax.tick_circle,
                        duration: 2000);

                    Navigator.pop(context);

                    print("Added $json in Community collection");

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
