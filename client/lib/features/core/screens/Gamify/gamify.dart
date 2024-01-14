import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/features/core/controllers/gamify_controller.dart';
import 'package:hestia/utils/constants/images_strings.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class Gamify extends StatelessWidget {
  final GamifyController gamifyController = GamifyController.instance;

  Gamify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.leaderboard),
        centerTitle: true,
        title: Text(
          "Leaderboard",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    LeaderboardRanks(
                      image: const AssetImage(MyAppImages.profile),
                      rank: "3",
                      color: Colors.brown.shade600,
                      rankColor: Colors.brown.shade600,
                      radius: 35,
                      points: "40k",
                      userName: "Mokkel",
                    ),
                  ],
                ),
                LeaderboardRanks(
                  image: const AssetImage(MyAppImages.profile2),
                  rank: "1",
                  color: Colors.yellow,
                  rankColor: Colors.yellow.shade600,
                  radius: 45,
                  points: "60k",
                  userName: "Leura Sharma",
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    LeaderboardRanks(
                      image: const AssetImage(MyAppImages.profile3),
                      rank: "2",
                      color: Colors.grey.shade600,
                      rankColor: Colors.grey.shade600,
                      radius: 35,
                      points: "20k",
                      userName: "Gladiator",
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => GamifyController
                      .instance.isAchievementClicked.value = true,
                  child: Obx(
                    () => GamifyTab(
                      text: "Achievement",
                      color: gamifyController.isAchievementClicked.value
                          ? Colors.teal.shade600
                          : Colors.teal.shade300,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => GamifyController
                      .instance.isAchievementClicked.value = false,
                  child: Obx(
                    () => GamifyTab(
                      text: "Tasks",
                      color: gamifyController.isAchievementClicked.value
                          ? Colors.teal.shade300
                          : Colors.teal.shade600,
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.teal.shade600,
              child: const Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AchievementCart(
                    achievementName: "Achievement 1",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 2",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 3",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 4",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 5",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 6",
                  ),
                  AchievementCart(
                    achievementName: "Achievement 7",
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AchievementCart extends StatelessWidget {
  const AchievementCart({
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
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
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

class GamifyTab extends StatelessWidget {
  const GamifyTab({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyAppHelperFunctions.screenWidth() / 2,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class LeaderboardRanks extends StatelessWidget {
  const LeaderboardRanks({
    super.key,
    required this.image,
    required this.rank,
    required this.color,
    this.radius = 50,
    required this.rankColor,
    this.userName = "UNKNOWN",
    required this.points,
  });

  final ImageProvider image;
  final String rank;
  final Color color, rankColor;
  final double radius;
  final String userName, points;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 2.5 * radius,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: color,
                        blurRadius: 15,
                        spreadRadius: 0.14 * radius)
                  ],
                ),
                child: CircleAvatar(
                  maxRadius: radius,
                  backgroundImage: image,
                ),
              ),
              Positioned(
                top: 1.6 * radius,
                left: radius - 0.36 * radius,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 0.36 * radius,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: rankColor,
                      child: Center(
                        child: Text(
                          rank,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 0.32 * radius),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Center(
            child: Text(
              userName,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.teal[300]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
            child: Row(
              children: [
                Text(
                  points,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
                const SizedBox(
                  width: 1,
                ),
                const Image(
                  image: AssetImage(MyAppImages.points),
                  fit: BoxFit.cover,
                  height: 25,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
