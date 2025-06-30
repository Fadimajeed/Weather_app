import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherLineChart extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final List<double> temperatures;
  final List<String> timeLabels;

  const WeatherLineChart({
    super.key,
    required this.temperatures,
    required this.timeLabels,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
  });

  // Helper function to get color based on temperature
  Color _getTemperatureColor(double temp) {
    if (temp < 0) {
      return Colors.blue.shade900; // Very cold
    } else if (temp >= 0 && temp < 10) {
      return Colors.blue.shade500; // Cold
    } else if (temp >= 10 && temp < 20) {
      return Colors.lightBlue; // Cool
    } else if (temp >= 20 && temp < 25) {
      return Colors.green; // Mild
    } else if (temp >= 25 && temp < 30) {
      return Colors.orange; // Warm
    } else {
      return Colors.red; // Hot
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = List.generate(
      temperatures.length,
      (index) => FlSpot(index.toDouble(), temperatures[index]),
    );

    // Create a list of colors for the gradient based on temperatures
    final List<Color> gradientColors = temperatures.map((temp) => _getTemperatureColor(temp)).toList();

    final double minY = temperatures.reduce((a, b) => a < b ? a : b) - 5; // Give some buffer
    final double maxY = temperatures.reduce((a, b) => a > b ? a : b) + 5; // Give some buffer

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20), 
      ),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false, 
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  // Very subtle grid lines
                  color: Colors.white.withOpacity(0.1), 
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}°',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, timeLabels),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                // Use a gradient for the line color
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white, // White dots for better visibility
                      strokeWidth: 2,
                      strokeColor: _getTemperatureColor(spot.y), // Dot border color based on temperature
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
                showingIndicators: List.generate(spots.length, (index) => index),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
     
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tooltipMargin: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((barSpot) {
                    return LineTooltipItem(
                      '${barSpot.y.toInt()}°',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList();
                },
              ),
              getTouchedSpotIndicator: (barData, indexes) {
                return indexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(color: Colors.white.withOpacity(0.5), strokeWidth: 2), // White indicator line
                    FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white, // Larger white dot on touch
                        strokeWidth: 2,
                        strokeColor: _getTemperatureColor(spot.y),
                      );
                    }),
                  );
                }).toList();
              },
              handleBuiltInTouches: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, List<String> labels) {
    const style = TextStyle(
      color: Colors.white70, 
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    int index = value.toInt();
    if (index < 0 || index >= labels.length) return Container();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(labels[index], style: style),
    );
  }
}
