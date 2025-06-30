import 'package:flutter/material.dart';
import 'cloud.dart';

class ThunderstormPainter extends CustomPainter {
  final Color cloudColor;
  final Color boltColor;

  ThunderstormPainter({
    this.cloudColor = Colors.white,
    this.boltColor = Colors.yellow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw cloud
    final cloud = CloudPainter(color: cloudColor);
    cloud.paint(canvas, Size(size.width, size.height * 0.6));

    // Draw bolt
    final paintBolt = Paint()
      ..color = boltColor
      ..style = PaintingStyle.fill;

    final w = size.width, h = size.height;
    final bolt = Path()
      ..moveTo(w * 0.55, h * 0.4)
      ..lineTo(w * 0.35, h * 0.75)
      ..lineTo(w * 0.5,  h * 0.75)
      ..lineTo(w * 0.45, h)
      ..lineTo(w * 0.75, h * 0.5)
      ..lineTo(w * 0.6,  h * 0.5)
      ..close();

    canvas.drawPath(bolt, paintBolt);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
