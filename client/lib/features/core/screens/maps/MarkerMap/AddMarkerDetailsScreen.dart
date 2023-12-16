import 'dart:io';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/data/repositories/firebase_query_repository/firebase_query_for_users.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';

// ignore: must_be_immutable
class ImageScreen extends StatelessWidget {
  ImageScreen(
      {super.key,
      required this.image,
      required this.position,
      required this.id,
      required this.customInfoWindowController});

  TextEditingController desc = TextEditingController();
  final File image;
  LatLng position;
  final int id;
  final CustomInfoWindowController customInfoWindowController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            image != File('') && image.existsSync()
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: Colors.black, width: 0.9),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 15,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Image.file(
                        image,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: desc,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Add Description",
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                constraints: const BoxConstraints(minHeight: 14.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => SizedBox(
                child: ElevatedButton(
                  child: MarkerMapController.instance.isloading.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 4,
                        )
                      : Text("Post"),
                  onPressed: () async {
                    MarkerMapController.instance.toggleIsLoading();
                    int randomMarkerID = DateTime.now().millisecondsSinceEpoch;
                    Marker marker = MarkerMapController.instance
                        .MakeFixedMarker(randomMarkerID, position,
                            customInfoWindowController, desc.text, image);

                    // Adding Marker details in Firestore
                    await FirebaseQueryForUsers()
                        .addMarkerToUser(position.latitude, position.longitude,
                            image, desc.text, randomMarkerID)
                        .then((value) =>
                            MarkerMapController.instance.toggleIsLoading())
                        .onError((error, stackTrace) =>
                            MarkerMapController.instance.toggleIsLoading());

                    Navigator.pop(context, marker);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
