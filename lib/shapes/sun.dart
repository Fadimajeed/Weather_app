import 'dart:math';
import 'package:flutter/material.dart';

class SunPainter extends CustomPainter {
  final Color color;

  SunPainter({this.color = Colors.yellow});

  @override
  void paint(Canvas canvas, Size size) {
    final paintSun = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final paintRay = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    // Core circle
    canvas.drawCircle(center, radius, paintSun);

    // 8 evenly spaced rays
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final end = Offset(
        center.dx + (radius * 1.4) * cos(angle),
        center.dy + (radius * 1.4) * sin(angle),
      );
      canvas.drawLine(start, end, paintRay);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
