import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hestia/bottom_nav_bar.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/authentication/screens/on_board/onBoarding.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  bool onboardingShown = GetStorage().read('onboardingShown') ?? true;
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward().whenComplete(() {
      onboardingShown
          ? Get.to(
              () => OnBoarding(),
              transition: Transition.topLevel,
              duration: const Duration(milliseconds: 1000),
            )
          : currentUser == null
              ? Get.to(
                  () => LoginScreen(),
                  transition: Transition.topLevel,
                  duration: const Duration(milliseconds: 1000),
                )
              : Get.to(
                  () => const BottomNavBar(),
                  transition: Transition.topLevel,
                  duration: const Duration(milliseconds: 1000),
                );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MyAppHelperFunctions.screenHeight() / 2 - 170,
          ),
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: const Image(
                image: AssetImage(MyAppImages.splashIcon),
                fit: BoxFit.fitHeight,
                height: 170,
                width: 170,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
