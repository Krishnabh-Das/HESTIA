
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/indivitual_user_post.dart';


class UserPostsListView extends StatelessWidget {
  const UserPostsListView({
    super.key,
    required this.settingsController1,
  });

  final settingsController settingsController1;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemBuilder: (_, index) {
          return Obx(
            () => Column(
              children: [
                IndivitualUserPost(
                  image: settingsController1.settingsUserPostDetails[index]
                      ["image"],
                  description: settingsController1
                      .settingsUserPostDetails[index]["desc"],
                  address: settingsController1.settingsUserPostDetails[index]
                      ["address"],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          );
        },
        itemCount: settingsController1.settingsUserPostDetails.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
