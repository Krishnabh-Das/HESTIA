import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class searchBar extends StatelessWidget {
  const searchBar({
    super.key,
    required this.markerMapController,
  });

  final MarkerMapController markerMapController;

  @override
  Widget build(BuildContext context) {
    var dark = MyAppHelperFunctions.isDarkMode(context);
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: markerMapController.searchController,
              style: TextStyle(color: MyAppColors.darkishGrey),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search Places",
                hintStyle:
                    const TextStyle(fontSize: 16, color: MyAppColors.darkGrey),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 12.0),
                constraints: const BoxConstraints(minHeight: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: markerMapController.placesList.value.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: () async {
                      // Add Marker & move Camera to the searched location
                      searchBarTapFunction(index);
                    },
                    title: Text(
                        markerMapController.placesList[index]['description']),
                  );
                })
          ],
        ),
      ),
    );
  }

  void searchBarTapFunction(int index) async {
    List<Location> locations = await locationFromAddress(
        markerMapController.placesList[index]['description']);
    LatLng searchPosition =
        LatLng(locations.last.latitude, locations.last.longitude);
    markerMapController.addTapMarkers(searchPosition, "Search Place");
    try {
      await markerMapController.googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(searchPosition, 16));
      print("Animate Camera Called");
    } catch (e) {
      print("Error animating camera: $e");
    }
  }
}
