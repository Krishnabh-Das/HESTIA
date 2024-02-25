import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hestia/common/common_values.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/screens/Community/widgets/swipe_button_donation.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/formatters/formatter.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hestia/features/core/screens/Community/community_screen.dart';

// ignore: must_be_immutable
class CommunityPostItem extends StatefulWidget {
  CommunityPostItem({
    super.key,
    required this.communityController,
    required this.name,
    required this.time,
    required this.desc,
    required this.image,
    this.isDonatePost = false,
    required this.noOfLikes,
    required this.postId,
    this.prof_image,
    this.hasUserLiked = false,
    this.total_shares = 0,
    this.total_comments,
  });

  final CommunityController communityController;
  final String name, time, desc;
  File image;
  final bool isDonatePost;
  int noOfLikes;
  final String postId;
  final File? prof_image;
  bool hasUserLiked;
  final int? total_shares;
  final int? total_comments;

  @override
  State<CommunityPostItem> createState() => _CommunityPostItemState();
}

class _CommunityPostItemState extends State<CommunityPostItem> {
  String? reportType;
  TextEditingController descController = TextEditingController();
  final _formKeyCommunity = GlobalKey<FormState>();
  TextEditingController userMessageControllerCommunity =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        widget.hasUserLiked = !widget.hasUserLiked;
        if (widget.hasUserLiked) {
          widget.noOfLikes++;
          CommunityController.instance.addOrRemoveLike(true, widget.postId);
        } else {
          widget.noOfLikes--;
          CommunityController.instance.addOrRemoveLike(false, widget.postId);
        }
        setState(() {});
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isDonatePost
                  ? const Color.fromARGB(255, 182, 237, 232)
                  : Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Name, Email & Time --Header
                      Row(
                        children: [
                          widget.prof_image != null
                              ? CircleAvatar(
                                  maxRadius: 22,
                                  backgroundImage:
                                      FileImage(widget.prof_image!),
                                )
                              : const CircleAvatar(
                                  maxRadius: 22,
                                  backgroundImage:
                                      AssetImage(MyAppImages.profile2),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  MyAppFormatter.formatStringSpaces(
                                      widget.name),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.time,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (widget.isDonatePost) ...[
                            Icon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: Colors.teal.shade600,
                            ),
                          ],
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
                              reportPostDialog(context);
                              debugPrint("Selected: $value");
                            },
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // -- Description
                      if (widget.desc != "") ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            widget.desc,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                      ],

                      const SizedBox(
                        height: 10,
                      ),

                      // -- Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(widget.image,
                            fit: BoxFit.cover,
                            height: 200,
                            width: MyAppHelperFunctions.screenWidth()),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      if (widget.isDonatePost) ...[
                        const SwipeButtonDonation(),
                        const SizedBox(
                          height: 12,
                        ),
                      ],

                      // -- Post Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          CommunityPostLikeButton(
                            communityController: widget.communityController,
                            iconData: Icons.favorite_outline_sharp,
                            no: widget.noOfLikes,
                            postId: widget.postId,
                            hasUserLiked: widget.hasUserLiked,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          CommunityPostCommentButton(
                              widget: widget,
                              userMessageControllerCommunity:
                                  userMessageControllerCommunity,
                              total_comments: widget.total_comments!,
                              post_id: widget.postId),
                          const SizedBox(
                            width: 24,
                          ),
                          CommunityPostShareButton(
                            image: widget.image,
                            desc: widget.desc,
                            name: widget.name,
                            post_id: widget.postId,
                            total_shares: widget.total_shares ?? 0,
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
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Future<dynamic> reportPostDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 340,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Stack(
                  children: [
                    Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              descController.text = "";
                            },
                            icon: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                )))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _formKeyCommunity,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Select Report Category',
                                  filled: true,
                                  fillColor: Colors.white),
                              items: CommonValues.categories
                                  .map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                reportType = newValue;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: descController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                  labelText: "Description",
                                  filled: true,
                                  fillColor: Colors.white),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "") {
                                  return 'Please give a report description';
                                }
                                return null;
                              },
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKeyCommunity.currentState!
                                        .validate()) {
                                      String response =
                                          await CommunityController.instance
                                              .reportPost(
                                                  widget.postId,
                                                  reportType!,
                                                  descController.text
                                                      .toString(),
                                                  AuthRepository()
                                                          .getUserId() ??
                                                      "",
                                                  widget.name,
                                                  "${DateTime.now()}");

                                      if (response == "done") {
                                        showCustomToast(context,
                                            color: Colors.green.shade600,
                                            text: "Reported Successfully",
                                            icon: Iconsax.tick_circle,
                                            duration: 2000);
                                        Navigator.of(context).pop();
                                        descController.text = "";
                                      } else {
                                        showCustomToast(context,
                                            color: Colors.red.shade600,
                                            text: response,
                                            duration: 2000,
                                            icon: Icons.cancel_rounded);
                                        Navigator.of(context).pop();
                                        descController.text = "";
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Submit",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.white),
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
