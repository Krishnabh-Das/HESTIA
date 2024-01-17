import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class AchievementIndivitualCard extends StatelessWidget {
  const AchievementIndivitualCard({
    super.key,
    required this.achievementName,
  });

  final String achievementName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Image(
            image: AssetImage(MyAppImages.star),
            fit: BoxFit.cover,
            height: 25,
          ),
          const Spacer(),
          Text(
            achievementName,
            style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Image(
            image: AssetImage(MyAppImages.share),
            fit: BoxFit.cover,
            height: 25,
          ),
        ],
      ),
    );
  }
}
