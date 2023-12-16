import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/features/authentication/controllers/signup_controller.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/common/widgets/text/authentication_rich_text.dart';
import 'package:hestia/features/authentication/screens/login/widgets/login_header_image.dart';
import 'package:hestia/features/authentication/screens/signup/widgets/signup_Text_Field.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:stroke_text/stroke_text.dart';

class signupScreen extends StatelessWidget {
  signupScreen({super.key});

  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final dark = MyAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? MyAppColors.darkBlack : MyAppColors.textWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header Image
            const loginHeaderImage(),

            // -- Login Details
            Padding(
              padding: const EdgeInsets.fromLTRB(MyAppSizes.defaultSpace, 0,
                  MyAppSizes.defaultSpace, MyAppSizes.defaultSpace),
              child: Transform.translate(
                offset: const Offset(0, -135),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    dark
                        ? Text(
                            "Create Account,",
                            style: GoogleFonts.robotoCondensed(
                              color: MyAppColors.textWhite,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : StrokeText(
                            text: "Create Account,",
                            textStyle: GoogleFonts.robotoCondensed(
                              color: MyAppColors.textWhite,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            strokeColor: Colors.black,
                            strokeWidth: 3,
                          ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwSections / 1.5,
                    ),

                    // Input Text Form Fields
                    SignupTextField(
                        email: controller.email,
                        password: controller.password,
                        confirmPassword: controller.confirmPassword),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwItems,
                    ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwItems / 1.7,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.signup(),
                        child: Text(
                          "Sign Up",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: MyAppColors.textWhite,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwSections / 1.5,
                    ),

                    // Sign Up Button
                    authenticationRichText(
                      text: "Already have an account? ",
                      OnPressText: "Sign In",
                      onTap: () => Get.offAll(() => LoginScreen()),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------------ Functions ------------------------------------
}
