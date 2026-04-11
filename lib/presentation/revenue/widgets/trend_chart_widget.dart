import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';

class TrendChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final TrendPeriod period;
  final DateTime? customStartDate;

  const TrendChartWidget({
    super.key,
    required this.spots,
    required this.period,
    this.customStartDate,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.isEmpty ? 0 : (spots.length - 1).toDouble(), // Explicitly set boundaries
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _getInterval(),
              getTitlesWidget: (value, meta) {
                // Return empty if value is out of bounds or not near an integer
                if (value < 0 || value >= spots.length) {
                  return const SizedBox.shrink();
                }
                
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  fitInside: SideTitleFitInsideData(
                    enabled: true,
                    axisPosition: meta.axisPosition,
                    parentAxisSize: meta.parentAxisSize,
                    distanceFromEdge: 0,
                  ),
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
                  ColourStyles.colorBlue.withValues(alpha: 0.2),
                  ColourStyles.colorBlue.withValues(alpha: 0.0),
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
                  NumberFormatterUtil.formatCurrency(spot.y),
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
    if (spots.length <= 1) return 1;
    // Always aim for exactly 5 labels (4 intervals) to keep distance perfectly even
    return (spots.length - 1) / 4;
  }

  String _getTitle(double value) {
    // Use rounding to pick the nearest data point for the calculated interval
    final index = value.round();
    
    if (value < -0.1 || index >= spots.length) {
      return "";
    }
    
    final now = DateTime.now();

    switch (period) {
      case TrendPeriod.day:
        return index == 0 ? "Yest" : "Today";
      case TrendPeriod.week:
        // Adjust index logic for week to show proper days if interval is not 1
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
      case TrendPeriod.custom:
        if (customStartDate != null) {
          final date = customStartDate!.add(Duration(days: index));
          return DateFormat('dd MMM').format(date);
        }
        return "";
    }
  }
}
