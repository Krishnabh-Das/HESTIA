import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/controllers/login_controller.dart';
import 'package:hestia/features/authentication/screens/login/widgets/loginTextField.dart';
import 'package:hestia/common/widgets/text/authentication_rich_text.dart';
import 'package:hestia/features/authentication/screens/login/widgets/login_header_image.dart';
import 'package:hestia/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:hestia/features/authentication/screens/signup/signup.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());
  final _formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dark = MyAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? MyAppColors.darkBlack : MyAppColors.textWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header Image
            const loginHeaderImage(height: 420),

            // -- Login Details
            Padding(
              padding: const EdgeInsets.fromLTRB(MyAppSizes.defaultSpace, 0,
                  MyAppSizes.defaultSpace, MyAppSizes.defaultSpace),
              child: Transform.translate(
                offset: const Offset(0, -100),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    /// Heading
                    Text(
                      "Welcome Back,",
                      style: GoogleFonts.robotoCondensed(
                        color: dark ? MyAppColors.textWhite : MyAppColors.black,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: MyAppSizes.spaceBtwSections / 1.5,
                    ),

                    /// Input Text Form Fields
                    Form(
                      key: _formKeyLogin,
                      child: LoginTextField(
                          email: controller.email,
                          password: controller.password),
                    ),

                    /// Forgot Password Text Button
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.to(() => ForgotPassword()),
                          child: Text("Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: dark
                                          ? MyAppColors.textWhite
                                          : MyAppColors.dark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                        )),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKeyLogin.currentState!.validate()) {
                            controller.signin(context);
                          }
                        },
                        child: Text(
                          "Login",
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

                    /// Go to Sign Up Text Button
                    authenticationRichText(
                      text: "Don't have an account? ",
                      OnPressText: "Sign Up",
                      onTap: () => Get.to(() => signupScreen()),
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
