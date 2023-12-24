import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/Donation/donation_Screen.dart';
import 'package:hestia/features/core/screens/home/home.dart';
import 'package:hestia/features/core/screens/maps/MarkerMap/MapScreen.dart';
import 'package:hestia/features/personalization/screens/settings/settings_screen.dart';
import 'package:iconsax/iconsax.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    final navBarController = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(
                icon: Icon(Iconsax.message_question), label: "Question"),
            NavigationDestination(icon: Icon(Icons.help), label: "Donate"),
            NavigationDestination(
                icon: Icon(Iconsax.setting), label: "Settings"),
          ],
          elevation: 0,
          height: 80,
          selectedIndex: navBarController.selectedIndex.value,
          onDestinationSelected: (value) {
            navBarController.selectedIndex.value = value;
          },
        ),
      ),
      body: Obx(
        () => navBarController.screens[navBarController.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  // Use a Map to store instances of the screens
  final screens = [
    MarkerMapScreen(),
    HomeScreen(),
    DonationScreen(),
    SettingsScreen(),
  ];

  @override
  void onClose() {
    // Perform cleanup or reset when the controller is closed
    print('NavigationController closed');
    super.onClose();
  }
}
