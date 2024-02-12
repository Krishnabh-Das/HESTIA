import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/custom_toast_message.dart';
import 'package:hestia/data/repositories/auth_repositories.dart';
import 'package:hestia/data/repositories/firebase_queries_for_sos/firebase_query_for_sos.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/controllers/sos_mini_map_controller.dart';
import 'package:iconsax/iconsax.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.descController,
    required this.addressController,
    required this.sosMiniMapController,
    required this.incidentTime,
    required this.crimeCategoryPicked,
    required this.imageFile,
    this.isResolved = false,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController descController;
  final TextEditingController addressController;
  final SOSMiniMapController sosMiniMapController;
  final DateTime? incidentTime;
  final crimeCategoryPicked;
  final imageFile;
  final bool isResolved;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              MarkerMapController.instance.toggleIsLoading();
              debugPrint("JSON Data:");
              debugPrint("incidentDescription: ${descController.text}");
              debugPrint("incidentAddress: ${addressController.text}");
              debugPrint("position: ${sosMiniMapController.tappedPosition}");
              debugPrint("incidentTime: $incidentTime");
              debugPrint("incidentCategory: $crimeCategoryPicked");
              await FirebaseQueryForSOS()
                  .saveData(
                      incidentDescription: descController.text,
                      incidentAddress: addressController.text,
                      position: sosMiniMapController.tappedPosition!,
                      incidentTime: incidentTime!,
                      incidentCategory: crimeCategoryPicked,
                      incidentImage: imageFile,
                      senderID: AuthRepository().getUserId(),
                      isResolved: isResolved)
                  .then((value) => showCustomToast(context,
                      color: Colors.green.shade400,
                      text: "SOS Alert Generated",
                      icon: Iconsax.tick_circle,
                      duration: 2000))
                  .onError((error, stackTrace) => showCustomToast(context,
                      color: Colors.red.shade400,
                      text: "Error Uploding Data in Database: $error",
                      icon: Icons.clear_sharp,
                      duration: 2000));
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
    );
  }
}
