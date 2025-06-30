import 'package:flutter/material.dart';

class SnowPainter extends CustomPainter {
  final Color color;

  SnowPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final c = Offset(size.width / 2, size.height / 2);
    final len = size.width * 0.25;

    // 6‑pointed star
    canvas.drawLine(Offset(c.dx, c.dy - len), Offset(c.dx, c.dy + len), paint);
    canvas.drawLine(Offset(c.dx - len, c.dy), Offset(c.dx + len, c.dy), paint);
    canvas.drawLine(Offset(c.dx - len * 0.7, c.dy - len * 0.7),
                    Offset(c.dx + len * 0.7, c.dy + len * 0.7), paint);
    canvas.drawLine(Offset(c.dx - len * 0.7, c.dy + len * 0.7),
                    Offset(c.dx + len * 0.7, c.dy - len * 0.7), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
