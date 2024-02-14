import 'package:flutter/material.dart';
import 'package:hestia/common/widgets/buttons/elevated_button_with_icon.dart';
import 'package:hestia/features/core/controllers/community_controller.dart';
import 'package:hestia/utils/constants/colors.dart';

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
