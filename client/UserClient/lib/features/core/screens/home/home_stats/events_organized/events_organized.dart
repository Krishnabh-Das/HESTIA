import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hestia/common/urlToFile.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';
import 'package:hestia/features/core/screens/home/home_stats/events_organized/volunteering_form.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/circular_score.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/current_address_and_button.dart';
import 'package:hestia/features/core/screens/home/sos/sos_screen.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';
import 'package:shimmer/shimmer.dart';

class EventsOrganized extends StatelessWidget {
  final HomeStatsRatingController homeStatsRatingController = Get.find();

  EventsOrganized({super.key}) {
    if (homeStatsRatingController.eventsPostList.isEmpty) {
      eventsOrganizedInit();
    }
  }

  // Future<void> eventsOrganizedInit() async {
  //   debugPrint(
  //       "homeStatsRatingController.eventsOrganizedRate.value: ${homeStatsRatingController.eventsOrganizedRate.value}");
  //   if (homeStatsRatingController.eventsOrganizedRate.value >= 0 &&
  //       homeStatsRatingController.eventsOrganizedMarkerMapList.isEmpty) {
  //     await homeStatsRatingController.crimeIncidentsMarker();
  //   }
  // }

  Future<void> eventsOrganizedInit() async {
    await homeStatsRatingController.getEventsPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 212, 212),
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
          "Events Organized",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Circular Score
              StatsHeaderCircularScore(
                homeStatsRatingRate:
                    homeStatsRatingController.eventsOrganizedRate,
              ),
              SizedBox(height: 20),

              // Events Post List View
              Obx(
                () => ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                  shrinkWrap: true,
                  itemCount: homeStatsRatingController.eventsPostList.length,
                  itemBuilder: (context, index) {
                    var mapValue =
                        homeStatsRatingController.eventsPostList[index];

                    return Column(
                      children: [
                        EventPost(
                          description: mapValue["eventDescription"],
                          eventName: mapValue["eventName"],
                          email: mapValue["eventContact"],
                          fromDate: mapValue["fromDate"],
                          toDate: mapValue["toDate"],
                          time: mapValue["time"],
                          type: mapValue["type"],
                          eventId: mapValue["eventId"],
                          address: mapValue["address"],
                          imageUrl: mapValue["poster"],
                        ),
                        Container(
                          height: 10,
                          color: const Color.fromARGB(255, 213, 212, 212),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventPost extends StatefulWidget {
  EventPost({
    super.key,
    required this.eventName,
    required this.time,
    required this.fromDate,
    required this.toDate,
    required this.email,
    required this.type,
    required this.description,
    required this.eventId,
    required this.address,
    required this.imageUrl,
  });

  final String eventName,
      time,
      fromDate,
      toDate,
      email,
      type,
      description,
      address,
      eventId,
      imageUrl;

  @override
  State<EventPost> createState() => _EventPostState();
}

class _EventPostState extends State<EventPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  File? image = null;

  Future<void> init() async {
    await urlToFile(widget.imageUrl).then((value) {
      if (value != null) {
        image = value;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MyAppHelperFunctions.screenWidth(),
          ),
          image != null
              ? Image(image: FileImage(image!))
              : Shimmer.fromColors(
                  child: Container(
                    width: double.infinity,
                    height: 250,
                  ),
                  baseColor: const Color.fromARGB(255, 68, 61, 61)!,
                  highlightColor: Colors.grey[100]!,
                ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.eventName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(
                        width: 8), // Adding some space between icon and text
                    Flexible(
                      child: Text(
                        "${widget.time}  ${widget.fromDate} - ${widget.toDate}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.location_city),
                    SizedBox(
                        width: 8), // Adding some space between icon and text
                    Flexible(
                      child: Text(
                        widget.address,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(
                        width: 8), // Adding some space between icon and text
                    Flexible(
                      child: Text(
                        widget.email,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.type_specimen),
                    SizedBox(
                        width: 8), // Adding some space between icon and text
                    Flexible(
                      child: Text(
                        widget.type,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => VolunteeringForm(
                        eventId: widget.eventId,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.app_registration,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Apply",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
