import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hestia/common/widgets/buttons/elevated_button_with_icon.dart';
import 'package:hestia/features/core/controllers/home_stats_ratings_controller.dart';

class StatsHeaderCurrentAddressAndButton extends StatelessWidget {
  const StatsHeaderCurrentAddressAndButton({
    super.key,
    required this.homeStatsRatingController,
    required this.buttonText,
    required this.onPressed,
  });

  final HomeStatsRatingController homeStatsRatingController;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () => Flexible(
                    child: Text(
                      homeStatsRatingController.currentAddress.value,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButtonWithIcon(
                  text: buttonText,
                  onPressed: onPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
