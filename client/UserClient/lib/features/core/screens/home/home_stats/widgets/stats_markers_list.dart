import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/features/core/screens/home/home_stats/widgets/stats_post.dart';
import 'package:shimmer/shimmer.dart';

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
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                    height: 330.0,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    )),
              )
            ]
          ],
        ),
      ),
    );
  }
}
