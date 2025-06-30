import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {
  final Color color;

  CloudPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final r = h * 0.5;

    // Three overlapping circles
    canvas.drawCircle(Offset(w * 0.25, h * 0.6), r, paint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.4), r * 0.9, paint);
    canvas.drawCircle(Offset(w * 0.75, h * 0.6), r, paint);

    // Base rectangle with rounded corners
    final rect = Rect.fromLTWH(w * 0.15, h * 0.55, w * 0.7, h * 0.3);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(h * 0.15)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
