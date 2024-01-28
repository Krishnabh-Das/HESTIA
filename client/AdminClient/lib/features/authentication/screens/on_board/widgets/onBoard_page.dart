import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class onBoardPage extends StatelessWidget {
  const onBoardPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageString,
  });

  final String title, subTitle, imageString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 130,
        ),
        Image(
          image: AssetImage(imageString),
          fit: BoxFit.fitHeight,
          height: 260,
        ),
        const SizedBox(
          height: 34,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
              fontSize: 15, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
