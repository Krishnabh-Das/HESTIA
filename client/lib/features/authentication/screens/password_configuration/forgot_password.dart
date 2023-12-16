import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/widgets/appbar/appbar.dart';
import 'package:hestia/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/constants/sizes.dart';
import 'package:hestia/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appBar(
        actions: [],
        showBackArrow: true,
        padding: EdgeInsets.symmetric(horizontal: 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MyAppSizes.defaultSpace * 0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Headings
              Text(
                MyAppTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: MyAppSizes.spaceBtwItems,
              ),
              Text(
                MyAppTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: MyAppSizes.spaceBtwSections,
              ),

              ///Text Field
              SizedBox(
                height: MyAppSizes.textFormFieldHeight,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: MyAppTexts.email,
                      prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),
              const SizedBox(
                height: MyAppSizes.spaceBtwSections * 0.7,
              ),

              ///Submit Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.off(() => VerifyAuthentication(
                            buttonText: MyAppTexts.resendEmail,
                            image: MyAppImages.email_verification,
                            title: MyAppTexts.changeYourPasswordTitle,
                            subtitle: MyAppTexts.changeYourPasswordSubTitle,
                          )),
                      child: Text(
                        MyAppTexts.submit,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: MyAppColors.textWhite),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
