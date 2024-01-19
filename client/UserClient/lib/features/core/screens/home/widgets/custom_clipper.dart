import 'package:flutter/material.dart';

class homeScreenCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    final first1 = Offset(0, size.height - 20);
    final second1 = Offset(20, size.height - 20);
    path.quadraticBezierTo(first1.dx, first1.dy, second1.dx, second1.dy);
    path.lineTo(55, size.height - 20);

    final first = Offset(50, size.height - 55);
    final second = Offset(90, size.height - 55);
    path.quadraticBezierTo(first.dx, first.dy, second.dx, second.dy);

    path.lineTo(size.width - 90, size.height - 55);

    final third = Offset(size.width - 50, size.height - 55);
    final fourth = Offset(size.width - 55, size.height - 20);
    path.quadraticBezierTo(third.dx, third.dy, fourth.dx, fourth.dy);

    path.lineTo(size.width - 20, size.height - 20);

    final first2 = Offset(size.width, size.height - 20);
    final second2 = Offset(size.width, size.height);
    path.quadraticBezierTo(first2.dx, first2.dy, second2.dx, second2.dy);

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
