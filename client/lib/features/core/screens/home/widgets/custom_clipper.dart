
import 'package:flutter/material.dart';

class homeScreenCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(50, size.height);

    final first = Offset(50, size.height - 45);
    final second = Offset(90, size.height - 45);
    path.quadraticBezierTo(first.dx, first.dy, second.dx, second.dy);

    path.lineTo(size.width - 90, size.height - 45);

    final third = Offset(size.width - 50, size.height - 45);
    final fourth = Offset(size.width - 50, size.height);
    path.quadraticBezierTo(third.dx, third.dy, fourth.dx, fourth.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
