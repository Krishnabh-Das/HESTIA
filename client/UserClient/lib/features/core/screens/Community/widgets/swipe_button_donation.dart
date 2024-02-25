// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:hestia/common/widgets/buttons/swipe_button_view/swipeable_button.dart';
import 'package:hestia/features/core/screens/Community/donation.dart';
import 'package:hestia/features/core/screens/MarkerMap/MapScreen.dart';
import 'package:page_transition/page_transition.dart';

class SwipeButtonDonation extends StatefulWidget {
  const SwipeButtonDonation({
    super.key,
  });

  @override
  State<SwipeButtonDonation> createState() => _SwipeButtonDonationState();
}

class _SwipeButtonDonationState extends State<SwipeButtonDonation> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SwipeableButtonView(
        buttonText: 'DONATE NOW',
        buttonWidget: Container(
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
          ),
        ),
        activeColor: Colors.teal,
        isFinished: isFinished,
        onWaitingProcess: () {
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              isFinished = true;
            });
          });
        },
        onFinish: () async {
          await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: DonationScreen()));

          setState(() {
            isFinished = false;
          });
        },
        iconHeight: 44,
        iconWidth: 44,
      ),
    );
  }
}
