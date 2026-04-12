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
  final bool isMonthly;

  const TrendChartWidget({
    super.key,
    required this.spots,
    required this.period,
    this.customStartDate,
    this.isMonthly = false,
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
                final index = value.round();
                // Return empty if value is out of bounds or not near an integer
                if (value < -0.1 || index >= spots.length) {
                  return const SizedBox.shrink();
                }

                // Precision filtering for labels
                bool shouldShow = false;
                if (period == TrendPeriod.month) {
                  // Show every 5 days OR the very last day of the month
                  shouldShow = (index % 5 == 0) || (index == spots.length - 1);
                } else if (period == TrendPeriod.year) {
                  // Final requested month list: Jan, Mar, May, Jun, Aug, Oct, Dec
                  final showIndices = [0, 2, 4, 5, 7, 9, 11];
                  shouldShow = showIndices.contains(index);
                } else {
                  // For other periods, the interval is already set to show all points
                  // or handled by the calculated interval for custom ranges.
                  shouldShow = true;
                }

                if (!shouldShow) return const SizedBox.shrink();


                return SideTitleWidget(
                  meta: meta,
                  space: 10,
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

    switch (period) {
      case TrendPeriod.day:
      case TrendPeriod.week:
      case TrendPeriod.sixMonths:
        return 1;
      case TrendPeriod.month:
      case TrendPeriod.year:
        return 1;
      case TrendPeriod.custom:
        final calculatedInterval = (spots.length - 1) / 4;
        // Ensure interval is at least 1 to prevent multiple labels for the same data point
        return calculatedInterval < 1 ? 1 : calculatedInterval;
    }
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
        // Align labels with current calendar week (Monday start)
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final date = monday.add(Duration(days: index));
        return DateFormat('E').format(date);
      case TrendPeriod.month:
        // Calendar month days start from 1 instead of 0
        return (index + 1).toString();
      case TrendPeriod.sixMonths:
        final date = DateTime(now.year, now.month - (5 - index), 1);
        return DateFormat('MMM').format(date);
      case TrendPeriod.year:
        final date = DateTime(now.year, index + 1, 1);
        return DateFormat('MMM').format(date);
      case TrendPeriod.custom:
        if (customStartDate != null) {
          if (isMonthly) {
            // If monthly, index refers to months
            final date =
                DateTime(customStartDate!.year, customStartDate!.month + index, 1);
            return DateFormat('MMM yyyy').format(date);
          } else {
            // If daily, index refers to days
            final date = customStartDate!.add(Duration(days: index));
            return DateFormat('dd MMM').format(date);
          }
        }
        return "";
    }
  }
}
