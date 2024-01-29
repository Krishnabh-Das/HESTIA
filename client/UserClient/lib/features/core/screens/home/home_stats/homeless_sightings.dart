import 'package:hestia/features/core/screens/MarkerMap/MapScreen.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/circular_score.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/current_address_and_button.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/stats_markers_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';

class HomelessSightings extends StatelessWidget {
  final HomeStatsRatingController homeStatsRatingController = Get.find();

  HomelessSightings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 69, 79),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Homeless Sightings",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // --Header
            Row(
              children: [
                /// Circular Score
                StatsHeaderCircularScore(
                    homeStatsRatingRate:
                        homeStatsRatingController.homelessSightingsRate),

                /// Current Address and Button
                StatsHeaderCurrentAddressAndButton(
                  homeStatsRatingController: homeStatsRatingController,
                  buttonText: "Add Hopeless Marker",
                  onPressed: () => Get.off(() => MarkerMapScreen(),
                      duration: Durations.extralong1, curve: Curves.easeInOut),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // --Marker Post List
            StatsPostList(
                homeStatsRatingList:
                    homeStatsRatingController.homelessSightingsMarkerMapList)
          ],
        ),
      ),
    );
  }
}
