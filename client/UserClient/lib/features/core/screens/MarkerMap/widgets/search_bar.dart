import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
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
              style: const TextStyle(color: MyAppColors.darkishGrey),
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
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                () => markerMapController.placesList.value.length != 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: markerMapController.placesList.value.length,
                        itemBuilder: (_, index) {
                          debugPrint(
                              "Every Place List: ${markerMapController.placesList[index]}");
                          return Column(
                            children: [
                              if (index == 0) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(
                                    () => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        margin: EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                            color: markerMapController
                                                    .searchBarLoading.value
                                                ? Colors.white
                                                : Colors.teal,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: markerMapController
                                                .searchBarLoading.value
                                            ? CircularProgressIndicator(
                                                color: Colors.teal,
                                              )
                                            : Text(
                                                "Search Results:",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                              ListTile(
                                onTap: () async {
                                  // Add Marker & move Camera to the searched location

                                  markerMapController.searchBarLoading.value =
                                      true;
                                  searchBarTapFunction(index);
                                },
                                title: Text(
                                  markerMapController.placesList[index]
                                      ['description'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              if (index !=
                                  markerMapController.placesList.value.length -
                                      1)
                                Divider(),
                            ],
                          );
                        })
                    : Text(
                        "   No Search Results   ",
                        style: TextStyle(color: Colors.grey),
                      ),
              ),
            )
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
    markerMapController.addTapMarkers(searchPosition, "Search Place",
        markerMapController.placesList[index]['description']);
    markerMapController.tapPosition = searchPosition;
    try {
      await markerMapController.googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(searchPosition, 16));
      debugPrint("Animate Camera Called");
      markerMapController.searchBarLoading.value = false;
      markerMapController.isSearchBarVisible.value = false;
    } catch (e) {
      debugPrint("Error animating camera: $e");
      markerMapController.searchBarLoading.value = false;
      markerMapController.isSearchBarVisible.value = false;
    }
  }
}
