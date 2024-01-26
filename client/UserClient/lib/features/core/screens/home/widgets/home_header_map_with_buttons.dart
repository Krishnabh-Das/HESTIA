import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hestia/features/core/controllers/half_map_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/home/widgets/custom_clipper.dart';
import 'package:hestia/features/core/screens/home/widgets/half_map_search_button.dart';
import 'package:hestia/features/core/screens/home/widgets/move_to_makrer_screen_button.dart';
import 'package:hestia/features/core/screens/home/widgets/sos_button.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class HomeHeaderMapWithButtons extends StatelessWidget {
  HomeHeaderMapWithButtons({
    super.key,
    required this.halfMapController,
  });

  final HalfMapController halfMapController;
  String mapTheme = "";

  @override
  Widget build(BuildContext context) {
    DefaultAssetBundle.of(context)
        .loadString("assets/map_style/aubergine.json")
        .then((value) {
      mapTheme = value;
    });
    return Stack(
      children: [
        // --Half Map Screen
        ClipPath(
          clipper: homeScreenCustomClipper(),
          child: SizedBox(
            height: MyAppHelperFunctions.screenHeight() / 2.5,
            child: Obx(
              () => MarkerMapController.instance.currPos.value == null
                  ? Center(
                      child: Text(
                        "Loading...",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    )
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: MarkerMapController.instance.currPos.value!,
                          zoom: 16,
                          tilt: 50),
                      onMapCreated: (controller) {
                        if (MyAppHelperFunctions.isNightTime()) {
                          controller.setMapStyle(mapTheme);
                        }
                        halfMapController.halfMapGoogleMapController =
                            controller;
                      },
                      markers: halfMapController.allHalfMapMarkers.value),
            ),
          ),
        ),

        // --HESTIA Token Display
        Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 60,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      image: AssetImage(MyAppImages.points),
                      fit: BoxFit.fitHeight,
                      height: 28,
                    ),
                    Text(
                      "460  TOKENS",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: MyAppColors.darkBlack),
                    ),
                    const Image(
                      image: AssetImage(MyAppImages.points),
                      fit: BoxFit.fitHeight,
                      height: 28,
                    ),
                  ],
                ),
              ),
            )),

        // Half Map Action Buttons
        const halfMapSearchButton(),
        const halfMapSOS(),
        const halfMapMoveToMarkerScreen(),
      ],
    );
  }
}
