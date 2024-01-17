import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/features/authentication/controllers/onBoarding_controller.dart';
import 'package:hestia/features/authentication/screens/on_board/widgets/onBoard_page.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});

  var onBoardController = Get.put(onBoardingController());

  @override
  Widget build(BuildContext context) {
    var dark = MyAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          // -- On Board Pages
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: PageView(
              controller: onBoardController.pageController,
              onPageChanged: (value) {
                onBoardController.currentPageIndex.value = value;
              },
              children: const [
                onBoardPage(
                  title: 'Welcome To HESTIA',
                  subTitle:
                      "HESTIA means Helping Everyone in Struggle Through Innovative Assistance. Our mission is to provide help to homeless people by involving our community.",
                  imageString: MyAppImages.onBoard1,
                ),
                onBoardPage(
                  title: 'Add Marker, Save Life',
                  subTitle:
                      "You can mark homeless people who need help in our map powered by Google Maps and we will share that information to people or groups who can help.",
                  imageString: MyAppImages.onBoard2,
                ),
                onBoardPage(
                  title: 'SOS System',
                  subTitle:
                      "You can also send SOS reports when you see a criminal incident against homeless people. We will send SOS alerts to the appropriate authorities.",
                  imageString: MyAppImages.onBoard3,
                ),
              ],
            ),
          ),

          // --Skip Button
          Positioned(
            bottom: 40,
            left: 30,
            child: GestureDetector(
              onTap: () => onBoardingController.instance.skipPage(),
              child: Text(
                "Skip",
                style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: dark ? MyAppColors.textWhite : Colors.black54),
              ),
            ),
          ),

          // --Navigation Dots
          Positioned(
            bottom: 48,
            left: MyAppHelperFunctions.screenWidth() / 2 - 50,
            child: SmoothPageIndicator(
              controller: onBoardController.pageController,
              count: 3,
              onDotClicked: onBoardController.dotNavigationClick,
              effect: ExpandingDotsEffect(
                  activeDotColor: dark ? MyAppColors.grey : MyAppColors.dark,
                  dotHeight: 6),
            ),
          ),

          // --Next Button
          Positioned(
            bottom: 40,
            right: 30,
            child: GestureDetector(
              onTap: () => onBoardingController.instance.nextPage(),
              child: Text(
                "Next",
                style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: dark ? MyAppColors.textWhite : Colors.black87),
              ),
            ),
          )
        ],
      ),
    );
  }
}
