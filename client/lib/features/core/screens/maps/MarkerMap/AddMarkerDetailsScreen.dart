import 'dart:io';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
            SizedBox(
              child: ElevatedButton(
                child: const Text("Post"),
                onPressed: () {
                  Marker marker = Marker(
                    markerId: MarkerId('$id'),
                    position: position,
                    draggable: true,
                    onDrag: (LatLng value) {
                      customInfoWindowController.hideInfoWindow!();

                      // Store the new position
                      position = value;

                      // Add a new info window at the updated position
                      customInfoWindowController.addInfoWindow!(
                        infoWindow(desc.text, image),
                        value,
                      );
                    },
                    onTap: () {
                      customInfoWindowController.addInfoWindow!(
                        infoWindow(desc.text, image),
                        position,
                      );
                    },
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  );

                  Navigator.pop(context, marker);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget infoWindow(String text, File image) {
    return Container(
      width: 250,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Colors.red[400],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
