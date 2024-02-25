import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/personalization/controllers/settings_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:hestia/utils/validators/validation.dart';
import 'package:image_picker/image_picker.dart';

class VolunteeringForm extends StatefulWidget {
  VolunteeringForm({super.key, required this.eventId});

  String eventId;

  @override
  State<VolunteeringForm> createState() => _VolunteeringFormState();
}

class _VolunteeringFormState extends State<VolunteeringForm> {
  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController email = TextEditingController();

  late File idProofImg;
  bool isIdProofImgPicked = false;

  late File profileImg;
  bool isprofileImgPicked = false;

  String? selectedGender;
  DateTime? selectedDate;

  final _formKeyVolunteering = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Volunteering Form",
        style: TextStyle(fontSize: 20),
      )),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKeyVolunteering,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.account_circle)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          MyAppValidator.validateEmail(value) ==
                              "Invalid email address.") {
                        return 'Please enter your Email ID';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "E-Mail", prefixIcon: Icon(Icons.email)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phone,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          MyAppValidator.validatePhoneNumber(value) ==
                              "Invalid phone number format (10 digits required)") {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            // Display the selected date in the text field if available
                            text: selectedDate != null
                                ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                                : '',
                          ),
                          readOnly: true, // Make the text field read-only
                          onTap: () async {
                            // Show date picker dialog
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            // Update selectedDate when a date is picked
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (selectedDate == null) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'DOB',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.people),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Others',
                              child: Text('Others'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedFile != null) {
                          File image = File(pickedFile.path);
                          setState(() {
                            idProofImg = image;
                            isIdProofImgPicked = true;
                          });
                        }
                      } catch (e) {}
                    },
                    child: isIdProofImgPicked
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              idProofImg!,
                              fit: BoxFit.cover,
                              height: 250,
                            ),
                          )
                        : Container(
                            width: MyAppHelperFunctions.screenWidth(),
                            height: 250,
                            decoration: BoxDecoration(
                                color: MyAppColors.primary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "ID PROOF",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white, fontSize: 24),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedFile != null) {
                          File image = File(pickedFile.path);
                          setState(() {
                            profileImg = image;
                            isprofileImgPicked = true;
                          });
                        }
                      } catch (e) {}
                    },
                    child: isprofileImgPicked
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              profileImg!,
                              fit: BoxFit.cover,
                              height: 250,
                            ),
                          )
                        : Container(
                            width: MyAppHelperFunctions.screenWidth(),
                            height: 250,
                            decoration: BoxDecoration(
                                color: MyAppColors.primary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "PROFILE IMAGE",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white, fontSize: 24),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (!isIdProofImgPicked && !isprofileImgPicked) {
                              showCustomToast(context,
                                  color: Colors.red,
                                  text: "Please upload the images required",
                                  duration: 2000,
                                  icon: Icons.cancel);
                            }
                            if (_formKeyVolunteering.currentState!.validate()) {
                              setState(() {
                                HomeStatsRatingController
                                    .instance.volunteerUploadLoad.value = true;
                              });

                              String idProofUrl = "";
                              String profileImageUrl = "";
                              await HomeStatsRatingController.instance
                                  .idProofImageUploadAndGetUrl(
                                      idProofImg!, widget.eventId)
                                  .then((value) => idProofUrl = value);
                              await HomeStatsRatingController.instance
                                  .volunteerImageUploadAndGetUrl(
                                      profileImg!, widget.eventId)
                                  .then((value) => profileImageUrl = value);

                              Map<String, dynamic> volunteerJson = {
                                "userName": name.text.toString(),
                                "userId": AuthRepository().getUserId(),
                                "email":
                                    FirebaseAuth.instance.currentUser!.email,
                                "idProofUrl": idProofUrl,
                                "profileImageUrl": profileImageUrl,
                                "phoneNumber": phone.text.toString(),
                                "dob": selectedDate,
                                "gender": selectedGender,
                                "status": "pending"
                              };

                              await HomeStatsRatingController.instance
                                  .uploadEventsVolunteerJSON(
                                      volunteerJson, widget.eventId);

                              setState(() {
                                HomeStatsRatingController
                                    .instance.volunteerUploadLoad.value = false;
                              });

                              showCustomToast(context,
                                  color: Colors.green,
                                  text: "Applied Successfully",
                                  duration: 2000,
                                  icon: Icons.check_circle);

                              Navigator.pop(context);
                            }
                          },
                          child: HomeStatsRatingController
                                  .instance.volunteerUploadLoad.value
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Submit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: Colors.white),
                                )))
                ],
              ),
            )),
      ),
    );
  }
}
