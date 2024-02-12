// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, duplicate_ignore

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/common/time_format.dart';
import 'package:hestia/common/widgets/buttons/elevated_button_with_icon.dart';
import 'package:hestia/common/widgets/buttons/swipe_button_view/swipeable_button.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/screens/Community/add_community_post.dart';
import 'package:hestia/features/core/screens/MarkerMap/MapScreen.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/formatters/formatter.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

// ignore: must_be_immutable
class CommunityScreen extends StatelessWidget {
  CommunityController communityController = CommunityController.instance;

  CommunityScreen({super.key}) {
    print(
        "communityController.isCommunityPostDataLoaded.value: ${communityController.isCommunityPostDataLoaded.value}");
    if (!communityController.isCommunityPostDataLoaded.value) {
      communityController.listOfCommunityPost.clear();
      communityScreeninit();
    }
  }

  Future<void> communityScreeninit() async {
    await CommunityController.instance.getPostFromCommunity();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
          onPressed: () => Get.to(() => const AddCommunityPost()),
          backgroundColor: const Color.fromARGB(255, 22, 90, 102),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          debugPrint("Refresh Called");
          communityController.listOfCommunityPost.clear();
          communityController.isCommunityPostDataLoaded.value = false;
          await communityScreeninit();
        },
        color: Colors.teal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: SearchBarWithPrefixAndSuffix(
                    searchController: searchController),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: ListView.builder(
                    shrinkWrap: true,
                    key: const PageStorageKey<String>('CommunityPostsListView'),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        // ignore: invalid_use_of_protected_member
                        communityController.listOfCommunityPost.value.length,
                    itemBuilder: (context, index) {
                      final individualPost =
                          // ignore: invalid_use_of_protected_member
                          communityController.listOfCommunityPost.value[index];

                      debugPrint(
                          "Individual post id: ${individualPost["Generic_Post_Info"]["post_id"]}");

                      bool hasUserLiked = individualPost["Generic_Post_Info"]
                              ["likes"]
                          .contains(AuthRepository().getUserId());

                      if (communityController.isCommunityPostDataLoaded.value) {
                        return Column(
                          children: [
                            CommunityPostItem(
                              communityController: communityController,
                              name: individualPost["Generic_Post_Info"]
                                  ["userName"],
                              time: formatTimestamp(
                                  individualPost["Generic_Post_Info"]["time"]),
                              desc: individualPost["Generic_Post_Info"]["desc"],
                              isDonatePost: individualPost["Generic_Post_Info"]
                                  ["isDonate"],
                              noOfLikes: individualPost["Generic_Post_Info"]
                                      ["likes"]
                                  .length,
                              postId: individualPost["Generic_Post_Info"]
                                  ["post_id"],
                              image: individualPost["Generic_Post_Info"]
                                  ["image"],
                              prof_image: individualPost["Generic_Post_Info"]
                                  ["prof_image"],
                              hasUserLiked: hasUserLiked,
                              total_shares: individualPost["Generic_Post_Info"]
                                      ["total_shares"] ??
                                  0,
                            ),
                            index ==
                                    communityController
                                            .listOfCommunityPost.value.length -
                                        1
                                ? LoadMoreCommunityButton(
                                    communityController: communityController)
                                : const SizedBox()
                          ],
                        );
                      } else {
                        return FutureBuilder<List<File?>>(
                          future: communityController.getImageFromCommunity(
                            index,
                            individualPost["Generic_Post_Info"]["post_id"],
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                    height: 330.0,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    )),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Error in Community Post List: ${snapshot.error}');
                            } else {
                              if (index ==
                                  communityController
                                          .listOfCommunityPost.value.length -
                                      1) {
                                communityController
                                    .isCommunityPostDataLoaded.value = true;
                              }
                              return Column(
                                children: [
                                  CommunityPostItem(
                                    communityController: communityController,
                                    name: individualPost["Generic_Post_Info"]
                                        ["userName"],
                                    time: formatTimestamp(
                                        individualPost["Generic_Post_Info"]
                                            ["time"]),
                                    desc: individualPost["Generic_Post_Info"]
                                        ["desc"],
                                    isDonatePost:
                                        individualPost["Generic_Post_Info"]
                                            ["isDonate"],
                                    noOfLikes:
                                        individualPost["Generic_Post_Info"]
                                                ["likes"]
                                            .length,
                                    postId: individualPost["Generic_Post_Info"]
                                        ["post_id"],
                                    image: snapshot.data![0]!,
                                    prof_image: snapshot.data![1],
                                    hasUserLiked: hasUserLiked,
                                    total_shares:
                                        individualPost["Generic_Post_Info"]
                                                ["total_shares"] ??
                                            0,
                                  ),
                                  index ==
                                          communityController
                                                  .listOfCommunityPost
                                                  .value
                                                  .length -
                                              1
                                      ? LoadMoreCommunityButton(
                                          communityController:
                                              communityController)
                                      : const SizedBox()
                                ],
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadMoreCommunityButton extends StatelessWidget {
  const LoadMoreCommunityButton({
    super.key,
    required this.communityController,
  });

  final CommunityController communityController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ElevatedButtonWithIcon(
        onPressed: () {
          communityController.isCommunityPostDataLoaded.value = false;
          communityController.loadMoreFromCommunity();
        },
        backgroundColor: Colors.transparent,
        text: "Load More",
        textColor: MyAppColors.darkerGrey,
        isImage: false,
        borderColor: MyAppColors.darkishGrey,
      ),
    );
  }
}

class CommunityPostItem extends StatelessWidget {
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
  });

  final CommunityController communityController;
  final String name, time, desc;
  File image;
  final bool isDonatePost;
  final int noOfLikes;
  final String postId;
  final File? prof_image;
  bool hasUserLiked;
  final int? total_shares;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDonatePost
                ? Color.fromARGB(255, 182, 237, 232)
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
                        prof_image != null
                            ? CircleAvatar(
                                maxRadius: 22,
                                backgroundImage: FileImage(prof_image!),
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
                                MyAppFormatter.formatStringSpaces(name),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                time,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (isDonatePost) ...[
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
                            print("Selected: $value");
                          },
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // -- Description
                    if (desc != "") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          desc,
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
                      child: Image.file(image,
                          fit: BoxFit.cover,
                          height: 200,
                          width: MyAppHelperFunctions.screenWidth()),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    if (isDonatePost) ...[
                      SwipeButtonDonation(),
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
                          communityController: communityController,
                          iconData: Icons.favorite_outline_sharp,
                          no: noOfLikes,
                          postId: postId,
                          hasUserLiked: hasUserLiked,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Icon(Icons.comment),
                        const SizedBox(
                          width: 24,
                        ),
                        CommunityPostShareButton(
                          image: image,
                          desc: desc,
                          name: name,
                          post_id: postId,
                          total_shares: total_shares ?? 0,
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
    );
  }
}

class CommunityPostShareButton extends StatefulWidget {
  CommunityPostShareButton({
    super.key,
    required this.image,
    required this.desc,
    required this.name,
    required this.post_id,
    this.total_shares = 0,
  });

  final File image;
  final String desc;
  final String name;
  final String post_id;
  int total_shares;

  @override
  State<CommunityPostShareButton> createState() =>
      _CommunityPostShareButtonState();
}

class _CommunityPostShareButtonState extends State<CommunityPostShareButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          showCustomToast(context,
              color: Colors.yellow.shade800,
              text: "Retrieving Image.....",
              duration: 2000,
              icon: Icons.sync);

          await Future.delayed(Durations.long1);

          // Read the image file
          Uint8List bytes = await widget.image.readAsBytes();

          // Decode the image
          img.Image? decodedImage = img.decodeImage(bytes);

          if (decodedImage != null) {
            // Encode the image to PNG format
            List<int> pngBytes = img.encodePng(decodedImage);

            // Write the PNG bytes to a temporary file
            File pngFile = await _writeTempFile(pngBytes);

            // Create an XFile from the PNG file
            XFile? xFile = XFile(pngFile.path);

            // Share the PNG file
            final box = context.findRenderObject() as RenderBox?;
            if (xFile != null) {
              // Share the PNG file
              final box = context.findRenderObject() as RenderBox?;
              final result = await Share.shareXFiles(
                [xFile],
                text: '${widget.desc}\n\nShared by ${widget.name}',
                subject: 'Hestia Community',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
              if (result.status == ShareResultStatus.success) {
                await CommunityController.instance.addShare(widget.post_id);
                widget.total_shares++;
                setState(() {});
              }
            } else {
              showCustomToast(context,
                  color: Colors.red,
                  text: "Error while sharing the image",
                  duration: 2000,
                  icon: Icons.error);
            }
          }
        },
        child: Row(
          children: [
            Icon(Icons.share),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${widget.total_shares}",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
            )
          ],
        ));
  }
}

Future<File> _writeTempFile(List<int> bytes) async {
  Directory tempDir = await getTemporaryDirectory();
  File tempFile = File('${tempDir.path}/Hestia Community.png');
  await tempFile.writeAsBytes(bytes);
  return tempFile;
}

class SwipeButtonDonation extends StatefulWidget {
  const SwipeButtonDonation({
    super.key,
  });

  @override
  State<SwipeButtonDonation> createState() => _SwipeButtonDonationState();
}

class _SwipeButtonDonationState extends State<SwipeButtonDonation> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SwipeableButtonView(
        buttonText: 'DONATE NOW',
        buttonWidget: Container(
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
          ),
        ),
        activeColor: Colors.teal,
        isFinished: isFinished,
        onWaitingProcess: () {
          Future.delayed(Duration(milliseconds: 800), () {
            setState(() {
              isFinished = true;
            });
          });
        },
        onFinish: () async {
          await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: MarkerMapScreen()));

          setState(() {
            isFinished = false;
          });
        },
        iconHeight: 44,
        iconWidth: 44,
      ),
    );
  }
}

class CommunityPostLikeButton extends StatefulWidget {
  CommunityPostLikeButton({
    Key? key,
    required this.communityController,
    required this.iconData,
    this.no = 0,
    required this.postId,
    this.hasUserLiked = false,
  }) : super(key: key);

  final CommunityController communityController;
  final IconData iconData;
  int no;
  final String postId;
  bool hasUserLiked = false;

  @override
  State<CommunityPostLikeButton> createState() => _CommunityPostButtonState();
}

class _CommunityPostButtonState extends State<CommunityPostLikeButton> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MyAppHelperFunctions.screenWidth();
    if (kDebugMode) {
      print("Screen Width: $screenWidth");
    }
    return GestureDetector(
      onTap: () {
        widget.hasUserLiked = !widget.hasUserLiked;
        if (widget.hasUserLiked) {
          widget.no++;
          CommunityController.instance.addOrRemoveLike(true, widget.postId);
        } else {
          widget.no--;
          CommunityController.instance.addOrRemoveLike(false, widget.postId);
        }
        setState(() {});
      },
      child: Row(
        children: [
          SizedBox(
            width: 0.001 * screenWidth,
          ),
          widget.hasUserLiked
              ? Icon(
                  Icons.favorite,
                  size: 0.08 * screenWidth,
                  color: Colors.red,
                )
              : Icon(
                  widget.iconData,
                  size: 0.08 * screenWidth,
                ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${widget.no}",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          )
        ],
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: MyAppColors.darkGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                const BorderSide(width: 0.5, color: MyAppColors.darkerGrey),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              IconButton(onPressed: () {}, icon: const Icon(Icons.tune))),
    );
  }
}
