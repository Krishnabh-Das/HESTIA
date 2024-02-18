import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/common_values.dart';
import 'package:hestia/features/core/controllers/sos_mini_map_controller.dart';
import 'package:hestia/features/core/screens/home/sos/widgets/form_submit_button.dart';
import 'package:hestia/features/core/screens/home/sos/widgets/incident_address.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:image_picker/image_picker.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreen();
}

class _SOSScreen extends State<SOSScreen> {
  bool isImagePicked = false;
  var imageFile;
  DateTime? incidentTime;
  var crimeCategoryPicked;
  TextEditingController descController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var sosMiniMapController = Get.put(SOSMiniMapController());

  @override
  Widget build(BuildContext context) {
    var dark = MyAppHelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: dark ? Colors.white : Colors.black,
              )),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "SOS",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                width: 15,
              ),
              const Image(
                image: AssetImage(MyAppImages.horn),
                fit: BoxFit.cover,
                height: 30,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Description
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: "Incident Description",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe the incident';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Address
                    IncidentAddress(
                        addressController: addressController,
                        sosMiniMapController: sosMiniMapController),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Incident Time
                    TextFormField(
                      readOnly: true,
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: "Time of Incident",
                      ),
                      onTap: () async {
                        var time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          setState(() {
                            incidentTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              time.hour,
                              time.minute,
                            );
                            timeController.text =
                                TimeOfDay.fromDateTime(incidentTime!)
                                    .format(context);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the time';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Category
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Select Crime Category',
                      ),
                      items: CommonValues.categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        crimeCategoryPicked = newValue;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Pick Image
                    GestureDetector(
                      onTap: () async {
                        try {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            File image = File(pickedFile.path);
                            setState(() {
                              imageFile = image;
                              isImagePicked = true;
                            });
                          }
                        } catch (e) {}
                      },
                      child: isImagePicked
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: MyAppColors.primary.withOpacity(0.7),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 80),
                              child: Text(
                                "Click to Select the Incident Image",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Form Submit Button
                    SubmitButton(
                        formKey: _formKey,
                        descController: descController,
                        addressController: addressController,
                        sosMiniMapController: sosMiniMapController,
                        incidentTime: incidentTime,
                        crimeCategoryPicked: crimeCategoryPicked,
                        imageFile: imageFile),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),
                  ],
                ),
              )),
        ));
  }
}
