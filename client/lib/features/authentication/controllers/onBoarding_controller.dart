import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';

class onBoardingController extends GetxController {
  static onBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to specific Page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update current index and jump to next page
  void nextPage() async {
    int nextPageIndex = currentPageIndex.value;
    if (nextPageIndex == 2) {
      onBoardingController.instance.dispose();
      GetStorage().write('onboardingShown', false);
      Get.offAll(() => LoginScreen(),
          transition: Transition.upToDown,
          duration: const Duration(milliseconds: 1500));
    } else {
      pageController.jumpToPage(++currentPageIndex.value);
    }
  }

  /// Upadte current index and jump to the last page
  void skipPage() async {
    onBoardingController.instance.dispose();
    GetStorage().write('onboardingShown', false);
    Get.offAll(() => LoginScreen(),
        transition: Transition.upToDown,
        duration: const Duration(milliseconds: 1500));
  }
}
