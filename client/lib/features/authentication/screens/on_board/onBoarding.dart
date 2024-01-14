import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/features/authentication/controllers/onBoarding_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});

  var onBoardController = Get.put(onBoardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PageView(
              controller: onBoardController.pageController,
              onPageChanged: (value) {
                onBoardController.currentPageIndex.value = value;
              },
              children: const [
                onBoardPage(
                  title: 'Welcome To HESTIA',
                  subTitle:
                      "Hestia is a Goddess Who Helps Everyone in Struggle Through Innovative Assistance",
                  imageString: MyAppImages.onBoard1,
                ),
                onBoardPage(
                  title: 'Add Marker, Save Life',
                  subTitle:
                      "You can add Markers in Map, which helps the social bodies to Navigate them, and securing their future",
                  imageString: MyAppImages.onBoard2,
                ),
                onBoardPage(
                  title: 'SOS System',
                  subTitle:
                      "If you found any Criminal Activity than Report the Incident in the SOS System.",
                  imageString: MyAppImages.onBoard3,
                ),
              ],
            ),
          ),
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
                    color: Colors.black54),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: MyAppHelperFunctions.screenWidth() / 2 - 50,
            child: SmoothPageIndicator(
              controller: onBoardController.pageController,
              count: 3,
              onDotClicked: onBoardController.dotNavigationClick,
              effect: const ExpandingDotsEffect(
                  activeDotColor: MyAppColors.dark, dotHeight: 6),
            ),
          ),
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
                    color: Colors.black87),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class onBoardPage extends StatelessWidget {
  const onBoardPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageString,
  });

  final String title, subTitle, imageString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 130,
        ),
        Image(
          image: AssetImage(imageString),
          fit: BoxFit.fitHeight,
          height: 260,
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(fontSize: 16, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
