import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/screens/Community/add_community_post.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  TextEditingController searchController = TextEditingController();
  CommunityController communityController = CommunityController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 69, 79),
        centerTitle: true,
        title: Text(
          "Community",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          child: Image(
            image: AssetImage(MyAppImages.communityIcon),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => AddCommunityPost()),
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: SearchBarWithPrefixAndSuffix(
                  searchController: searchController),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  CommunityPostItem(
                      communityController: communityController,
                      name: "Krishnabh Das",
                      time: "12:55 AM, Saturday",
                      desc:
                          "Hello my name is krishnabh i m currently studying at assam engineering college",
                      image: MyAppImages.login_image),
                  CommunityPostItem(
                      communityController: communityController,
                      name: "Krishnabh Das",
                      time: "12:55 AM, Saturday",
                      desc:
                          "Hello my name is krishnabh i m currently studying at assam engineering college",
                      image: MyAppImages.login_image),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommunityPostItem extends StatelessWidget {
  const CommunityPostItem({
    super.key,
    required this.communityController,
    required this.name,
    required this.time,
    required this.desc,
    required this.image,
  });

  final CommunityController communityController;
  final String name, time, desc, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 0.7)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Name, Email & Time --Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Column(
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                time,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          iconSize: 24,
                          color: Colors.white,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              padding: EdgeInsets.all(0),
                              value: "Post",
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Report Post",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            print("Selected: $value");
                          },
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // -- Image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(image: AssetImage(image))),

                    const SizedBox(
                      height: 10,
                    ),

                    // -- Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Text(
                        desc,
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // -- Post Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommunityPostButton(
                          communityController: communityController,
                          buttonText: "Like",
                          iconData: Icons.thumb_up,
                        ),
                        CommunityPostButton(
                          communityController: communityController,
                          buttonText: "Comment",
                          iconData: Icons.comment,
                          isTappable: false,
                        ),
                        CommunityPostButton(
                          communityController: communityController,
                          buttonText: "Share",
                          iconData: Icons.share,
                          isTappable: false,
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class CommunityPostButton extends StatefulWidget {
  const CommunityPostButton({
    Key? key,
    required this.communityController,
    required this.buttonText,
    required this.iconData,
    this.isTappable = true,
  }) : super(key: key);

  final CommunityController communityController;
  final String buttonText;
  final IconData iconData;
  final bool isTappable;

  @override
  State<CommunityPostButton> createState() => _CommunityPostButtonState();
}

class _CommunityPostButtonState extends State<CommunityPostButton> {
  bool isLikedPressed = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MyAppHelperFunctions.screenWidth();
    print("Screen Width: $screenWidth");
    return GestureDetector(
      onTap: () {
        widget.isTappable ? isLikedPressed = !isLikedPressed : null;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0138 * screenWidth),
        padding: EdgeInsets.symmetric(
            horizontal: 0.027 * screenWidth, vertical: 0.022 * screenWidth),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            SizedBox(
              width: 0.0055 * screenWidth,
            ),
            Text(
              widget.buttonText,
              style: TextStyle(
                  fontSize: 0.0333 * screenWidth,
                  color: isLikedPressed
                      ? widget.isTappable
                          ? Colors.blue
                          : Colors.black
                      : Colors.black),
            ),
            SizedBox(
              width: 0.0277 * screenWidth,
            ),
            widget.isTappable
                ? isLikedPressed
                    ? Icon(
                        widget.iconData,
                        size: 0.0417 * screenWidth,
                        color: Colors.blue,
                      )
                    : Icon(
                        widget.iconData,
                        size: 0.0417 * screenWidth,
                      )
                : Icon(
                    widget.iconData,
                    size: 0.0417 * screenWidth,
                  )
          ],
        ),
      ),
    );
  }
}

class SearchBarWithPrefixAndSuffix extends StatelessWidget {
  const SearchBarWithPrefixAndSuffix({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          hintText: 'Search...',
          hintStyle: TextStyle(color: MyAppColors.darkGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 0.5, color: MyAppColors.darkerGrey),
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.tune))),
    );
  }
}
