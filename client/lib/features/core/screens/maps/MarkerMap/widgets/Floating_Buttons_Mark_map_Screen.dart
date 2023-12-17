import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/authentication/screens/login/login_screen.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';

class FloatingButtonsMarkerMapScreen extends StatelessWidget {
  const FloatingButtonsMarkerMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.only(top: 28, right: 12),
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "changeMap",
            onPressed: () => MarkerMapController.instance.toggleMap(),
            backgroundColor: const Color.fromARGB(255, 89, 187, 92),
            mini: true,
            child: const Icon(
              Icons.map,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "moveToCurr",
            onPressed: () => MarkerMapController.instance.moveToCurrLocation(),
            backgroundColor: Colors.indigoAccent,
            mini: true,
            child: const Icon(
              Icons.track_changes_outlined,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "OpenCamera",
            onPressed: () => MarkerMapController.instance.getImage(true),
            backgroundColor: Colors.red[400],
            mini: true,
            child: const Icon(
              Icons.camera_alt,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "OpenGallery",
            onPressed: () => MarkerMapController.instance.getImage(false),
            backgroundColor: Colors.indigo[400],
            mini: true,
            child: const Icon(
              Icons.photo,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "DeleteMarker",
            onPressed: () =>
                MarkerMapController.instance.deleteMarkersExceptFixed(),
            backgroundColor: Colors.yellow[600],
            mini: true,
            child: const Icon(
              Icons.delete,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "ShowPolygons",
            onPressed: () => MarkerMapController.instance.toggleShowPolygon(),
            backgroundColor: Colors.pink[300],
            mini: true,
            child: const Icon(
              Icons.polymer_rounded,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              heroTag: "logout",
              onPressed: () async =>
                  await FirebaseAuth.instance.signOut().then((value) {
                Get.offAll(() => LoginScreen());
              }),
              backgroundColor: Colors.redAccent,
              mini: true,
              child: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
