// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, duplicate_ignore
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/common/time_format.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/features/core/screens/Community/add_community_post.dart';
import 'package:hestia/features/core/screens/Community/widgets/community_post_button.dart';
import 'package:hestia/features/core/screens/Community/widgets/post_load_mode_button.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;

// ignore: must_be_immutable
class CommunityScreen extends StatelessWidget {
  CommunityController communityController = CommunityController.instance;

  CommunityScreen({super.key}) {
    debugPrint(
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
                              total_comments:
                                  individualPost["Generic_Post_Info"]
                                          ["total_comments"] ??
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
                                    total_comments:
                                        individualPost["Generic_Post_Info"]
                                                ["total_comments"] ??
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

class CommunityPostCommentButton extends StatefulWidget {
  CommunityPostCommentButton(
      {super.key,
      required this.widget,
      required this.userMessageControllerCommunity,
      required this.total_comments});

  final CommunityPostItem widget;
  final TextEditingController userMessageControllerCommunity;
  int total_comments;

  @override
  State<CommunityPostCommentButton> createState() =>
      _CommunityPostCommentButtonState();
}

class _CommunityPostCommentButtonState
    extends State<CommunityPostCommentButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.teal.shade100,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            builder: (context) => Container(
                  constraints: const BoxConstraints(minHeight: 340),
                  child: Wrap(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border:
                                Border.all(width: 2, color: Colors.black45)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              // --User Text Form Field
                              Expanded(
                                  flex: 9,
                                  child: TextFormField(
                                    controller:
                                        widget.userMessageControllerCommunity,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: const InputDecoration(
                                      hintText: "Type Your Message....",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  )),

                              // --User Text Upload IconButton
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () async {
                                        String name = settingsController
                                            .instance.name.value;
                                        String comment = widget
                                            .userMessageControllerCommunity.text
                                            .toString();
                                        String userId =
                                            AuthRepository().getUserId()!;

                                        await CommunityController.instance
                                            .uploadUserComment(name, comment,
                                                userId, widget.widget.postId);
                                        widget.userMessageControllerCommunity
                                            .text = "";
                                        widget.total_comments++;
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.forward,
                                        color: MyAppColors.darkBlack,
                                      )))
                            ],
                          ),
                        ),
                      ),
                      const CommentMsgCommunity(
                          name: "Hello Mishra",
                          desc:
                              "The human beings are always like this i know for sure mf"),
                      const CommentMsgCommunity(
                          name: "Hello Mishra",
                          desc:
                              "The human beings are always like i know for sure mf"),
                    ],
                  ),
                ));
      },
      child: Row(
        children: [
          const Icon(Icons.comment),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${widget.total_comments}",
          ),
        ],
      ),
    );
  }
}

class CommentMsgCommunity extends StatelessWidget {
  const CommentMsgCommunity({
    super.key,
    required this.name,
    required this.desc,
  });

  final String name, desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.white),
      child: ListTile(
        title: Text(
          name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Text(
          desc,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        trailing: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 1,
                ),
                Text(
                  "2",
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            )),
      ),
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
          }
        },
        child: Row(
          children: [
            const Icon(Icons.share),
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
