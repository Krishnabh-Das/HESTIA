import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/core/controllers/tokens_controller.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/ChatBot/chat_bot.dart';
import 'package:hestia/features/core/screens/Community/community_screen.dart';
import 'package:hestia/features/core/screens/Tokens/tokens.dart';
import 'package:hestia/features/core/screens/home/home.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/features/personalization/screens/settings/settings_screen.dart';
import 'package:iconsax/iconsax.dart';

class bottomNavBar extends StatelessWidget {
  bottomNavBar({super.key}) {
    MarkerMapController.instance.initData();
  }

  @override
  Widget build(BuildContext context) {
    final navBarController = Get.put(NavigationController());
    final pageController = PageController();

    return PopScope(
      onPopInvoked: (didPop) {
        MarkerMapController.instance.dispose();
        settingsController.instance.dispose();
        HalfMapController.instance.dispose();
        TokensController.instance.dispose();
        ChatBotController.instance.dispose();
        NavigationController.instance.dispose();
        HomeStatsRatingController.instance.dispose();
        print("Will Pop Called");
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.leaderboard_outlined), label: "Tokens"),
              NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline_sharp),
                  label: "Chatbot"),
              NavigationDestination(
                  icon: Icon(Iconsax.setting), label: "Settings"),
            ],
            elevation: 0,
            height: 80,
            selectedIndex: navBarController.selectedIndex.value,
            onDestinationSelected: (value) {
              // Set the selected index directly without animation
              navBarController.selectedIndex.value = value;

              // Jump directly to the selected page
              pageController.jumpToPage(value);
            },
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            CommunityScreen(),
            ChatScreen(),
            SettingsScreen(),
          ],
          onPageChanged: (index) {
            navBarController.selectedIndex.value = index;
          },
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  Rx<int> selectedIndex = 0.obs;

  @override
  void onClose() {
    print('NavigationController closed');

    super.onClose();
  }
}
