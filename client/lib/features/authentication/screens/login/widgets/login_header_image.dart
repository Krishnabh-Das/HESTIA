import 'package:flutter/material.dart';
import 'package:hestia/utils/constants/colors.dart';
import 'package:hestia/utils/constants/images_strings.dart';

class loginHeaderImage extends StatelessWidget {
  const loginHeaderImage({
    super.key,
    this.height = 400,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [MyAppColors.transperant, MyAppColors.black],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: const Image(
          image: AssetImage(MyAppImages.login_image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
