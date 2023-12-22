import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';

import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/device/device_utility.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController1 = Get.put(settingsController());
  SettingsScreen({super.key}) {
    _initData();
  }

  Future<void> _initData() async {
    await settingsController1.getSettingsUserProfileDetails();
    await settingsController1.getSettingsUserPostData();
    await settingsController1.getTotalPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1F616B),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Obx(
            () => Column(
              children: [
                // Primary Header
                primaryHeader(
                  onPressed: () {},
                ),

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
                              left: 22, right: 22, top: 40, bottom: 22),
                          child: Column(
                            children: [
                              settingsProfileField(
                                column1String: "Name",
                                column2String: settingsController.instance
                                    .settingUserProfileDetails.value["name"],
                              ),
                              SizedBox(height: 20),
                              settingsProfileField(
                                column1String: "Email ID",
                                column2String:
                                    FirebaseAuth.instance.currentUser?.email,
                              ),
                              SizedBox(height: 20),
                              settingsProfileField(
                                column1String: "Date Of Birth",
                                column2String: settingsController.instance
                                    .settingUserProfileDetails.value["dob"],
                              ),
                              SizedBox(height: 20),
                              settingsProfileField(
                                column1String: "Total Posts",
                                column2String:
                                    "${settingsController1.totalPost.value}",
                              ),
                            ],
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
}

class settingsProfileField extends StatelessWidget {
  const settingsProfileField({
    super.key,
    required this.column1String,
    this.column2String,
  });

  final String column1String;
  final String? column2String;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.grey.shade300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
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
              width: 15,
            ),
            Expanded(
              child: Text(
                column2String ?? "--------",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class primaryHeader extends StatelessWidget {
  const primaryHeader({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: [
          Positioned(
            top: -MyAppDeviceUtils.getScreenWidth(context) / 4.8,
            left: 0,
            right: 0,
            child: Container(
              height: MyAppDeviceUtils.getScreenWidth(context),
              width: MyAppDeviceUtils.getScreenWidth(context),
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
          AppBar(
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
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  settingsController
                          .instance.settingUserProfileDetails.value["name"] ??
                      "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700),
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
          Positioned(
            top: 215,
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
                    child: CircleAvatar(
                      radius: 50, // Adjust the radius as per your design
                      backgroundImage: AssetImage(MyAppImages.profile2),
                    ),
                  )),
            ),
          ),
          Positioned(
              top: 285,
              left: MyAppDeviceUtils.getScreenWidth(context) / 1.75,
              child: IconButton(
                  onPressed: onPressed,
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
