import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/stats_post.dart';

class StatsPostList extends StatelessWidget {
  const StatsPostList({
    super.key,
    required this.homeStatsRatingList,
  });

  final RxList<dynamic> homeStatsRatingList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
        () => Column(
          children: [
            for (var map in homeStatsRatingList.value) ...[
              StatsPost(
                time: map["time"],
                description: map["desc"],
                address: map["address"],
                image: map["image"],
              )
            ],
            // ignore: invalid_use_of_protected_member
            if (homeStatsRatingList.value.isEmpty) ...[
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  "No Crimes Reported Nearby",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
