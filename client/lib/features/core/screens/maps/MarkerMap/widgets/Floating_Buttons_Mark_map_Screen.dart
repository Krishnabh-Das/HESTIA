import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
