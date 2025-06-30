import 'package:flutter/material.dart';
import 'cloud.dart';
class RainPainter extends CustomPainter {
  final Color color;

  RainPainter({this.color = Colors.lightBlueAccent});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw a simple cloud behind raindrops
    final cloud = CloudPainter(color: Colors.white);
    cloud.paint(canvas, Size(size.width, size.height * 0.5));

    // Raindrop paint
    final dropPaint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startY = size.height * 0.55;
    final len = size.height * 0.25;
    final gap = size.width * 0.2;

    // Three drops
    for (int i = 0; i < 3; i++) {
      final x = size.width * 0.3 + i * gap;
      canvas.drawLine(Offset(x, startY), Offset(x, startY + len), dropPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


