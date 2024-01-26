import 'package:flutter/material.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/leaderboard_indivitual_rank.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class LeaderBoardRankTop3 extends StatelessWidget {
  const LeaderBoardRankTop3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            LeaderboardIndivitualRank(
              image: const AssetImage(MyAppImages.profile),
              rank: "3",
              color: Colors.brown.shade600,
              rankColor: Colors.brown.shade600,
              radius: 35,
              points: "40k",
              userName: "Rahul Dev",
            ),
          ],
        ),
        LeaderboardIndivitualRank(
          image: const AssetImage(MyAppImages.profile2),
          rank: "1",
          color: Colors.yellow,
          rankColor: Colors.yellow.shade600,
          radius: 45,
          points: "60k",
          userName: "Mina Sharma",
        ),
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            LeaderboardIndivitualRank(
              image: const AssetImage(MyAppImages.profile3),
              rank: "2",
              color: Colors.grey.shade600,
              rankColor: Colors.grey.shade600,
              radius: 35,
              points: "20k",
              userName: "Kuldeep",
            ),
          ],
        ),
      ],
    );
  }
}
