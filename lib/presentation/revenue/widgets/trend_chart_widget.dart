import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';

class TrendChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final TrendPeriod period;

  const TrendChartWidget({
    super.key,
    required this.spots,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _getInterval(),
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    _getTitle(value),
                    style: TextStyle(
                      color: ColourStyles.captionColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ColourStyles.colorBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColourStyles.colorBlue.withOpacity(0.2),
                  ColourStyles.colorBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => ColourStyles.primaryColor_2,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  "\$${spot.y.toStringAsFixed(2)}",
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double _getInterval() {
    switch (period) {
      case TrendPeriod.day:
        return 1;
      case TrendPeriod.week:
        return 1;
      case TrendPeriod.month:
        return 5;
      case TrendPeriod.sixMonths:
        return 1;
      case TrendPeriod.year:
        return 2;
    }
  }

  String _getTitle(double value) {
    if (value < 0 || value >= spots.length && period != TrendPeriod.month) return "";
    final now = DateTime.now();
    final index = value.toInt();

    switch (period) {
      case TrendPeriod.day:
        return index == 0 ? "Yest" : "Today";
      case TrendPeriod.week:
        final date = now.subtract(Duration(days: 6 - index));
        return DateFormat('E').format(date);
      case TrendPeriod.month:
        final date = now.subtract(Duration(days: 29 - index));
        return date.day.toString();
      case TrendPeriod.sixMonths:
        final date = DateTime(now.year, now.month - (5 - index), 1);
        return DateFormat('MMM').format(date);
      case TrendPeriod.year:
        final date = DateTime(now.year, index + 1, 1);
        return DateFormat('MMM').format(date);
    }
  }
}
