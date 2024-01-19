import 'package:flutter/material.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/achievement_card.dart';

class AchievementCards extends StatelessWidget {
  const AchievementCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF1F616B),
      child: const Column(
        children: [
          SizedBox(
            height: 20,
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 1",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 2",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 3",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 4",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 5",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 6",
          ),
          AchievementIndivitualCard(
            achievementName: "Achievement 7",
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
