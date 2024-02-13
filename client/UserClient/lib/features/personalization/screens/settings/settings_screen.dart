import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/indivitual_profile_field.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/logout_button.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/post_tab_button.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/primary_header.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/profile_tab_button.dart';
import 'package:hestia/features/personalization/screens/settings/widgets/user_post_list_view.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController settingsController1 = Get.find();
  var nameTextEditingController = TextEditingController();
  var dobTextEditingController = TextEditingController();

  SettingsScreen({super.key}) {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await settingsController1.getSettingsUserPostData();
      debugPrint("User Post dat has been called");
    } catch (e) {
      debugPrint("Settings Screen Error: $e");
    }
    try {
      await settingsController1.getTotalPost();
    } catch (e) {
      print("Settings Screen Error: $e");
    }
    try {
      await settingsController1.getSettingsUserProfileDetails();
    } catch (e) {
      debugPrint("Settings Screen Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff1F616B),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // -- Primary Header
            PrimaryHeader(
                screenWidth: screenWidth,
                settingsController1: settingsController1),

            // -- Post & Profile Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostTabButton(settingsController1: settingsController1),
                  ProfileTabButton(settingsController1: settingsController1),
                ],
              ),
            ),

            // -- Post & Profile Button Tabs
            Obx(
              () => Container(
                child: settingsController1.isPostSelected.value

                    /// User Post
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 22, right: 22, top: 0, bottom: 22),
                        child: UserPostsListView(
                            settingsController1: settingsController1),
                      )

                    /// User Profile
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 22, right: 22, top: 30, bottom: 22),
                        child: Obx(
                          () => Column(
                            children: [
                              IndivitualProfileField(
                                column1String: "Name",
                                column2String:
                                    settingsController.instance.name.value,
                                onPressed: () {
                                  profileEditDialog(
                                      context,
                                      nameTextEditingController,
                                      "Name",
                                      Icons.person);
                                },
                              ),

                              const SizedBox(height: 20),

                              IndivitualProfileField(
                                column1String: "Email ID",
                                column2String:
                                    FirebaseAuth.instance.currentUser?.email,
                                isEditable: false,
                              ),

                              const SizedBox(height: 20),

                              IndivitualProfileField(
                                column1String: "Date Of Birth",
                                column2String:
                                    settingsController.instance.dob.value,
                                onPressed: () {
                                  profileEditDialog(
                                      context,
                                      dobTextEditingController,
                                      "Date Of Birth",
                                      Icons.calendar_month);
                                },
                              ),

                              const SizedBox(height: 20),

                              Obx(
                                () => IndivitualProfileField(
                                  column1String: "Total Posts",
                                  column2String:
                                      "${settingsController1.totalPost.value}",
                                  isEditable: false,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // -- Log Out Button
                              const LogOutButton()
                            ],
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  // --------------------------------------  FUNCTIONS  -------------------------------------------

  Future<dynamic> profileEditDialog(
      BuildContext context,
      TextEditingController textEditingController,
      String labelName,
      IconData icon) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 1,
                      controller: textEditingController,
                      decoration: InputDecoration(
                          constraints: const BoxConstraints(minHeight: 14.0),
                          prefixIcon:
                              textEditingController == nameTextEditingController
                                  ? Icon(icon)
                                  : datePickerIconButton(
                                      context, textEditingController, icon),
                          labelText: labelName),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            textEditingController == nameTextEditingController
                                ? settingsController1.updateNameInProfile(
                                    textEditingController.text)
                                : settingsController1.updateDOBInProfile(
                                    textEditingController.text);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "SUBMIT",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Padding datePickerIconButton(BuildContext context,
      TextEditingController textEditingController, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: IconButton(
            onPressed: () async {
              DateTime? datePicked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now());
              if (datePicked != null) {
                textEditingController.text =
                    "${datePicked.day}/${datePicked.month}/${datePicked.year}";
              }
            },
            icon: Icon(
              icon,
              size: 20,
            )),
      ),
    );
  }
}
