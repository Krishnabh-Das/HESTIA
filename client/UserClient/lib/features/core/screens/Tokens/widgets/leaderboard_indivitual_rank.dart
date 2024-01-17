import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class LeaderboardIndivitualRank extends StatelessWidget {
  const LeaderboardIndivitualRank({
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyAppColors.darkBlack),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF1F616B)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
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
                  width: 4,
                ),
                const Image(
                  image: AssetImage(MyAppImages.pointsWhite),
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
