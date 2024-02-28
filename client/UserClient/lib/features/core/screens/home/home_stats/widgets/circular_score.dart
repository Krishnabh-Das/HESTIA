import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class StatsHeaderCircularScore extends StatelessWidget {
  const StatsHeaderCircularScore({
    super.key,
    required this.homeStatsRatingRate,
  });

  final Rx<double> homeStatsRatingRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyAppHelperFunctions.screenWidth() / 2.5,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(color: Colors.grey, spreadRadius: 5, blurRadius: 15)
      ], shape: BoxShape.circle, color: Colors.teal.shade300),
      child: Center(
          child: Obx(
        () => Text(
          "${homeStatsRatingRate.value}",
          softWrap: true,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white, fontSize: 22),
        ),
      )),
    );
  }
}
