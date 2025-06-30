import 'package:flutter/material.dart';

class MoonPainter extends CustomPainter {
  final Color color;

  MoonPainter({this.color = Colors.white70});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final R = size.width * 0.4;
    final dx = R * 0.3;

    final full = Path()..addOval(Rect.fromCircle(center: center, radius: R));
    final cutout = Path()..addOval(Rect.fromCircle(center: center.translate(-dx, 0), radius: R));
    final crescent = Path.combine(PathOperation.difference, full, cutout);

    canvas.drawPath(crescent, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
