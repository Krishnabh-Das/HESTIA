import 'package:flutter/material.dart';
import 'package:hestia/features/core/controllers/tokens_controller.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/achievement_cards.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/leaderboard_rank_top3.dart';
import 'package:hestia/features/core/screens/Tokens/widgets/tab_button.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class Tokens extends StatelessWidget {
  final TokensController tokensController = TokensController.instance;

  Tokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 69, 79),
        leading: const Icon(
          Icons.leaderboard,
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          "Leaderboard",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
      ),
      body: const SingleChildScrollView(
        physics: RangeMaintainingScrollPhysics(),
        child: Stack(
          children: [
            // --Token Screen Background
            Image(
              image: AssetImage(MyAppImages.emojiBackground),
              fit: BoxFit.fitHeight,
            ),

            // --Screen Content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                ),

                /// Leaderboard Ranks
                LeaderBoardRankTop3(),

                SizedBox(
                  height: 35,
                ),

                /// Tabs
                TabButton(),

                /// Achievement Cards
                AchievementCards()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
