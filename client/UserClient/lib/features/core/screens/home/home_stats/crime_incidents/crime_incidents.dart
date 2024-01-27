import 'dart:io';
import 'dart:isolate';
import 'package:hestia/common/widgets/buttons/elevated_button_with_icon.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/circular_score.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/current_address_and_button.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/stats_markers_list.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/stats_post.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hestia/common/getPlacemart.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/core/controllers/marker_map_controller.dart';
import 'package:hestia/features/core/screens/home/sos/sos_screen.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';

class CrimeIncidents extends StatelessWidget {
  final HomeStatsRatingController homeStatsRatingController = Get.find();

  CrimeIncidents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 69, 79),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Crime Incidents",
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
                    homeStatsRatingRate: homeStatsRatingController.crimeRate),

                /// Current Address and Button
                StatsHeaderCurrentAddressAndButton(
                  homeStatsRatingController: homeStatsRatingController,
                  buttonText: "Add SOS",
                  onPressed: () => Get.off(() => SOSScreen(),
                      duration: Durations.extralong1,
                      curve: Curves.easeInOutCubicEmphasized),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // --Marker Post List
            StatsPostList(
                homeStatsRatingList:
                    homeStatsRatingController.crimeMarkerMapList)
          ],
        ),
      ),
    );
  }
}
