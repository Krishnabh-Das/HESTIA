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

class signupScreen extends StatelessWidget {
  signupScreen({super.key});

  final signUpController = Get.put(SignupController());
  final _formKeySignup = GlobalKey<FormState>();

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
                    /// Heading
                    Text(
                      "Create Account,",
                      style: GoogleFonts.robotoCondensed(
                        color: dark ? MyAppColors.textWhite : MyAppColors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwSections / 1.5,
                    ),

                    /// Input Text Form Fields
                    Form(
                      key: _formKeySignup,
                      child: SignupTextField(
                          email: signUpController.email,
                          password: signUpController.password,
                          confirmPassword: signUpController.confirmPassword),
                    ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwItems * 1.59,
                    ),

                    /// Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKeySignup.currentState!.validate()) {
                            signUpController.signup();
                          }
                        },
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

                    // Go to Sign In Text Button
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
}
