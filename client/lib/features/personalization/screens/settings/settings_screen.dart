import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:hestia/data/repositories/firebase_query_for_profile/firebase_query_for_profile.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';

import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/device/device_utility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController1 = Get.put(settingsController());
  var nameTextEditingController = TextEditingController();
  var dobTextEditingController = TextEditingController();

  SettingsScreen({super.key}) {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await settingsController1.getSettingsUserPostData();
    } catch (e) {
      print("Settings Screen Error: $e");
    }
    try {
      await settingsController1.getTotalPost();
    } catch (e) {
      print("Settings Screen Error: $e");
    }
    try {
      settingsController1.profileImage.value =
          await settingsController1.getProfileImageFromBackend();
    } catch (e) {
      print("Settings Screen Error: $e");
    }
    try {
      await settingsController1.getSettingsUserProfileDetails();
    } catch (e) {
      print("Settings Screen Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xff1F616B),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Obx(
            () => Column(
              children: [
                // Primary Header

                primaryHeader(
                    screenWidth: screenWidth,
                    settingsController1: settingsController1),

                // Post & Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      postButton(settingsController1: settingsController1),
                      profileButton(settingsController1: settingsController1),
                    ],
                  ),
                ),

                // Post & Profile Button Tabs
                Container(
                  child: settingsController1.isPostSelected.value
                      // User Post
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 0, bottom: 22),
                          child: userPostsListView(
                              settingsController1: settingsController1),
                        )
                      // User Profile
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 30, bottom: 22),
                          child: Obx(
                            () => Column(
                              children: [
                                settingsProfileField(
                                  column1String: "Name",
                                  column2String:
                                      settingsController.instance.name.value,
                                  onPressed: () {
                                    profileEditDialog(
                                        context,
                                        nameTextEditingController,
                                        "Name",
                                        Icons.person);
                                  },
                                ),
                                SizedBox(height: 20),
                                settingsProfileField(
                                  column1String: "Email ID",
                                  column2String:
                                      FirebaseAuth.instance.currentUser?.email,
                                  isEditable: false,
                                ),
                                SizedBox(height: 20),
                                settingsProfileField(
                                  column1String: "Date Of Birth",
                                  column2String:
                                      settingsController.instance.dob.value,
                                  onPressed: () {
                                    profileEditDialog(
                                        context,
                                        dobTextEditingController,
                                        "Date Of Birth",
                                        Icons.calendar_month);
                                  },
                                ),
                                SizedBox(height: 20),
                                settingsProfileField(
                                  column1String: "Total Posts",
                                  column2String:
                                      "${settingsController1.totalPost.value}",
                                  isEditable: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }

  Future<dynamic> profileEditDialog(
      BuildContext context,
      TextEditingController textEditingController,
      String labelName,
      IconData icon) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 1,
                      controller: textEditingController,
                      decoration: InputDecoration(
                          constraints: BoxConstraints(minHeight: 14.0),
                          prefixIcon:
                              textEditingController == nameTextEditingController
                                  ? Icon(icon)
                                  : datePickerIconButton(
                                      context, textEditingController, icon),
                          labelText: labelName),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            textEditingController == nameTextEditingController
                                ? settingsController1.updateNameInProfile(
                                    textEditingController.text)
                                : settingsController1.updateDOBInProfile(
                                    textEditingController.text);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "SUBMIT",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Padding datePickerIconButton(BuildContext context,
      TextEditingController textEditingController, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: IconButton(
            onPressed: () async {
              DateTime? datePicked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now());
              if (datePicked != null) {
                textEditingController.text =
                    "${datePicked.day}/${datePicked.month}/${datePicked.year}";
              }
            },
            icon: Icon(
              icon,
              size: 20,
            )),
      ),
    );
  }
}

class primaryHeader extends StatelessWidget {
  const primaryHeader({
    super.key,
    required this.screenWidth,
    required this.settingsController1,
  });

  final double screenWidth;
  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenWidth * 0.95,
      child: Stack(
        children: [
          // Background Circle
          Positioned(
            top: -screenWidth / 4.8,
            left: 0,
            right: 0,
            child: Container(
              height: screenWidth,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        MyAppDeviceUtils.getScreenWidth(context)),
                    bottomRight: Radius.circular(
                        MyAppDeviceUtils.getScreenWidth(context))),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 7, 112, 82),
                    Color(0xFF00D47E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            left: 0,
            right: 0,
            top: -10,
            child: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              centerTitle: true,
              leading: Icon(
                Iconsax.setting,
                color: Colors.white,
              ),
            ),
          ),

          // Name & Email
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    settingsController.instance.name.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${FirebaseAuth.instance.currentUser?.email}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Profile Image
          Positioned(
            top: screenWidth * 0.6,
            left: MyAppDeviceUtils.getScreenWidth(context) / 2 - 48,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade300),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            settingsController.instance.profileImage.value !=
                                    null
                                ? Image.file(settingsController
                                        .instance.profileImage.value!)
                                    .image
                                : AssetImage(MyAppImages.profile2),
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
              top: screenWidth * 0.79,
              left: MyAppDeviceUtils.getScreenWidth(context) / 1.75,
              child: IconButton(
                  onPressed: () async {
                    try {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        File? image = File(pickedFile.path);

                        await firebaseQueryForProfile()
                            .uploadImageToBackend(image);

                        settingsController1.profileImage.value = image;

                        settingsController1.update();
                      }
                    } catch (e) {
                      print("Error picking image: $e");
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}

class settingsProfileField extends StatelessWidget {
  const settingsProfileField({
    super.key,
    required this.column1String,
    this.column2String,
    this.isEditable = true,
    this.onPressed,
  });

  final String column1String;
  final String? column2String;
  final bool isEditable;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.grey.shade300),
      child: Padding(
        padding: isEditable
            ? EdgeInsets.fromLTRB(30, 18, 10, 18)
            : EdgeInsets.fromLTRB(30, 18, 35, 18),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                column1String,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                column2String ?? "--------",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isEditable) ...[
              SizedBox(
                width: 7,
              ),
              Container(
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5, color: Colors.grey)),
                child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                    )),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class profileButton extends StatelessWidget {
  const profileButton({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => settingsController1.toggleIsPostSelected(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100)),
            color: !settingsController1.isPostSelected.value
                ? Color.fromARGB(204, 0, 212, 127)
                : Colors.grey),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 7, 30, 7),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class postButton extends StatelessWidget {
  const postButton({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => settingsController1.toggleIsPostSelected(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100)),
            color: settingsController1.isPostSelected.value
                ? Color.fromARGB(204, 0, 212, 127)
                : Colors.grey),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 7, 40, 7),
          child: Row(
            children: [
              Icon(
                Icons.handshake_outlined,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Posts",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// User Post list View
class userPostsListView extends StatelessWidget {
  const userPostsListView({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemBuilder: (_, index) {
          return Column(
            children: [
              settingsUserPost(
                image: settingsController1.settingsUserPostDetails[index]
                    ["image"],
                description: settingsController1.settingsUserPostDetails[index]
                    ["desc"],
              ),
              SizedBox(
                height: 15,
              )
            ],
          );
        },
        itemCount: settingsController1.settingsUserPostDetails.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

// Indivitual User Post
class settingsUserPost extends StatelessWidget {
  const settingsUserPost({
    super.key,
    required this.image,
    required this.description,
    this.location = "Guwahati Railway Station",
  });

  final File image;
  final String description;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.9)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.file(image),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
                Expanded(
                  child: Text(
                    "Guwahati Railway Station",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Text(
                description,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
