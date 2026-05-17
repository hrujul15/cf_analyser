import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RatingGraph extends StatelessWidget {
  final List<int> ratingHistory;

  const RatingGraph({super.key, required this.ratingHistory});

  @override
  Widget build(BuildContext context) {
    if (ratingHistory.isEmpty) {
      return const Center(
        child: Text("No rating data", style: TextStyle(color: Colors.white54)),
      );
    }
    final minRating = ratingHistory.reduce((a, b) => a < b ? a : b);
    final maxRating = ratingHistory.reduce((a, b) => a > b ? a : b);
    double roundedMin = (minRating ~/ 100) * 100;
    double roundedMax = ((maxRating + 99) ~/ 100) * 100;
    final spots = [
      for (int i = 0; i < ratingHistory.length; i++)
        FlSpot(i.toDouble() + 1, ratingHistory[i].toDouble()),
    ];
    int ratingInterval;
    if (roundedMax <= 1200) {
      ratingInterval = 100;
    } else if (roundedMax <= 2400) {
      ratingInterval = 200;
    } else if (roundedMax <= 3600) {
      ratingInterval = 300;
    } else {
      ratingInterval = 400;
    }

    int contests = ratingHistory.length + 1;
    int contestsInterval = ((contests / 20).floor()) * 2;
    if (contestsInterval == 0) contestsInterval = 1;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 600,
        width: double.infinity,
        child: LineChart(
          LineChartData(
            minY: roundedMin.toDouble(),
            maxY: roundedMax.toDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                gradient: LinearGradient(colors: [Colors.cyan, Colors.blue]),
                dotData: FlDotData(show: true),
              ),
            ],
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: contestsInterval.toDouble(),
                  getTitlesWidget: (value, meta) {
                    if ((value % contestsInterval != 0)) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,

                  interval: ratingInterval.toDouble(),
                  getTitlesWidget: (value, meta) {
                    if ((roundedMax % ratingInterval != 0 &&
                            value == roundedMax) ||
                        (roundedMin % ratingInterval != 0 &&
                            value == roundedMin)) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white54),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: ratingInterval.toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
