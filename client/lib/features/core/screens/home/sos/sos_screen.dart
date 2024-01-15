import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/data/repositories/firebase_queries_for_sos/firebase_query_for_sos.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/controllers/sos_mini_map_controller.dart';
import 'package:hestia/features/core/screens/home/sos/custom_map_select_dialog.dart';
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
  List<String> categories = <String>[
    'Physical Assault',
    'Verbal Abuse',
    'Sexual Misconduct',
    'Discrimination',
    'Substance Abuse',
    'Public Nuisance',
    'Exploitation',
    'Trafficking/Kidnapping',
    'Bullying',
    'Other'
  ];

  bool isImagePicked = false;
  late var imageFile;
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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: TextFormField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              labelText: "Address of Incident",
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomMapSelectDialog(
                                          sosMiniMapController:
                                              sosMiniMapController,
                                        ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle),
                                child: const Image(
                                  image: AssetImage(MyAppImages.markerImage),
                                  fit: BoxFit.fitHeight,
                                  height: 37,
                                ),
                              ),
                            ))
                      ],
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),

                    // Time
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
                      items: categories.map((String category) {
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

                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              MarkerMapController.instance.toggleIsLoading();
                              print("JSON Data:");
                              print(
                                  "incidentDescription: ${descController.text}");
                              print(
                                  "incidentAddress: ${addressController.text}");
                              print(
                                  "position: ${sosMiniMapController.tappedPosition}");
                              print("incidentTime: $incidentTime");
                              print("incidentCategory: $crimeCategoryPicked");
                              await FirebaseQueryForSOS().saveData(
                                  incidentDescription: descController.text,
                                  incidentAddress: addressController.text,
                                  position:
                                      sosMiniMapController.tappedPosition!,
                                  incidentTime: incidentTime!,
                                  incidentCategory: crimeCategoryPicked,
                                  incidentImage: imageFile);
                              sosMiniMapController.dispose();
                              MarkerMapController.instance.toggleIsLoading();
                              Navigator.of(context).pop();
                            }
                          },
                          child: MarkerMapController.instance.isloading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Submit'),
                        ),
                      ),
                    ),

                    SizedBox(
                        height: MyAppHelperFunctions.screenHeight() * 0.02),
                  ],
                ),
              )),
        ));
  }
}
