import 'dart:math' as math;
import 'package:flutter/material.dart';


class SunriseSunsetArcWidget extends StatelessWidget {
  final TimeOfDay sunriseTime;
  final TimeOfDay sunsetTime;
  final TimeOfDay currentTime; // To position the sun
  final Color arcColor;
  final Color sunColor;
  final Color textColor;
  final Color markerColor;

  const SunriseSunsetArcWidget({
    super.key,
    required this.sunriseTime,
    required this.sunsetTime,
    required this.currentTime,
    this.arcColor = Colors.white54,
    this.sunColor = Colors.yellow,
    this.textColor = Colors.white,
    this.markerColor = Colors.white70,
  });

  // Helper to convert TimeOfDay to minutes from midnight
  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Helper to format TimeOfDay (e.g., 6:30 AM)
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    // ... inside SunriseSunsetArcWidget build method ...

    final sunriseMinutes = _timeToMinutes(sunriseTime);
    final sunsetMinutes = _timeToMinutes(sunsetTime);
    final currentMinutes = _timeToMinutes(currentTime);

    debugPrint("Sunrise Time: $sunriseTime ($sunriseMinutes minutes)");
    debugPrint("Sunset Time: $sunsetTime ($sunsetMinutes minutes)");
    debugPrint("Current Time: $currentTime ($currentMinutes minutes)");

    // Calculate the percentage of the day that has passed between sunrise and sunset
    final totalDayMinutes = sunsetMinutes - sunriseMinutes;
    final elapsedMinutes = currentMinutes - sunriseMinutes;

    debugPrint("Total Day Minutes (Sunset - Sunrise): $totalDayMinutes");
    debugPrint("Elapsed Minutes (Current - Sunrise): $elapsedMinutes");

    // Ensure elapsedMinutes is within the sunrise/sunset range for positioning
    final double progressPercent = totalDayMinutes <= 0
        ? 0.5 // Default to noon if times are invalid or same
        : (elapsedMinutes / totalDayMinutes).clamp(0.0, 1.0);

    debugPrint("Calculated Progress Percent: $progressPercent");


    return Container(
      padding: const EdgeInsets.all(20.0),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row for Sunrise and Sunset labels and times
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        'Sunrise',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                      Icon(Icons.sunny, color: Colors.yellow, size: 30),
                    ],
                  ),

                  Text(
                    _formatTime(sunriseTime),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.dark_mode, color: Colors.blueGrey, size: 30),
                      Text(
                        'Sunset',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    _formatTime(sunsetTime),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Custom painter for the arc and sun
          AspectRatio(
            aspectRatio: 2 / 1, // Adjust aspect ratio as needed
            child: CustomPaint(
              painter: _SunriseSunsetArcPainter(
                progressPercent: progressPercent,
                arcColor: arcColor,
                sunColor: sunColor,
                markerColor: markerColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// Custom Painter for the arc
class _SunriseSunsetArcPainter extends CustomPainter {
  final double progressPercent; // 0.0 (sunrise) to 1.0 (sunset)
  final Color arcColor;
  final Color sunColor;
  final Color markerColor;

  _SunriseSunsetArcPainter({
    required this.progressPercent,
    required this.arcColor,
    required this.sunColor,
    required this.markerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height;
    final double radius = size.width / 2 * 0.9; // Adjust radius factor
    final Rect arcRect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: radius,
    );
    const double startAngle = math.pi; // Start angle (left side)
    const double sweepAngle = math.pi; // Sweep angle (180 degrees)

    // Paint for the dashed arc
    final Paint arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw the dashed arc
    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double start = startAngle;
    while (start < startAngle + sweepAngle) {
      final double end = math.min(
        start + dashWidth / radius,
        startAngle + sweepAngle,
      );
      canvas.drawArc(arcRect, start, end - start, false, arcPaint);
      start += (dashWidth + dashSpace) / radius;
    }

    // Calculate sun position on the arc
    final double sunAngle = startAngle + sweepAngle * progressPercent;
    final double sunX = centerX + radius * math.cos(sunAngle);
    final double sunY = centerY + radius * math.sin(sunAngle);
    final Offset sunPosition = Offset(sunX, sunY);

    // Paint for the sun
    final Paint sunPaint = Paint()
      ..color = sunColor
      ..style = PaintingStyle.fill;

    // Draw the sun
    canvas.drawCircle(sunPosition, 8.0, sunPaint); // Adjust sun size

    _drawMarker(
      canvas,
      size,
      radius,
      centerX,
      centerY,
      0.15,
      'golden hour',
    ); // ~15% mark
    _drawMarker(
      canvas,
      size,
      radius,
      centerX,
      centerY,
      0.85,
      'blue hour',
    ); // ~85% mark
  }

  void _drawMarker(
    Canvas canvas,
    Size size,
    double radius,
    double centerX,
    double centerY,
    double percent,
    String label,
  ) {
    final double markerAngle = math.pi + math.pi * percent;
    final double markerX = centerX + radius * math.cos(markerAngle);
    final double markerY = centerY + radius * math.sin(markerAngle);
    final Offset markerPos = Offset(markerX, markerY);

    // Draw small line marker
    final Paint markerPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final double lineLength = 8.0;
    final double lineEndX =
        markerX +
        lineLength *
            math.cos(markerAngle - math.pi / 2); // Perpendicular outwards
    final double lineEndY =
        markerY + lineLength * math.sin(markerAngle - math.pi / 2);
    canvas.drawLine(markerPos, Offset(lineEndX, lineEndY), markerPaint);

    // Draw text label
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: markerColor, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    // Position text slightly above the marker line end
    final double textX =
        lineEndX +
        5 * math.cos(markerAngle - math.pi / 2) -
        textPainter.width / 2;
    final double textY =
        lineEndY +
        5 * math.sin(markerAngle - math.pi / 2) -
        textPainter.height / 2;
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant _SunriseSunsetArcPainter oldDelegate) {
    return oldDelegate.progressPercent != progressPercent ||
        oldDelegate.arcColor != arcColor ||
        oldDelegate.sunColor != sunColor ||
        oldDelegate.markerColor != markerColor;
  }
}
