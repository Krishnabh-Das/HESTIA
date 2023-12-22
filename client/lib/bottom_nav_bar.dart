import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hestia/features/core/screens/Donation/donation_Screen.dart';
import 'package:hestia/features/core/screens/home/home.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/MapScreen.dart';
import 'package:hestia/features/personalization/screens/settings/settings_screen.dart';
import 'package:iconsax/iconsax.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Iconsax.message_question), label: "Question"),
          NavigationDestination(icon: Icon(Icons.help), label: "Donate"),
          NavigationDestination(icon: Icon(Iconsax.setting), label: "Settings"),
        ],
        elevation: 0,
        height: 80,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (value) =>
            controller.selectedIndex.value = value,
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  var screens = [
    MarkerMapScreen(),
    HomeScreen(),
    DonationScreen(),
    SettingsScreen()
  ];
}
