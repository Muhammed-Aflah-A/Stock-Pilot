import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';
import 'package:stock_pilot/presentation/revenue/widgets/trend_chart_widget.dart';

class SalesTrendsWidget extends StatelessWidget {
  const SalesTrendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueProvider>(
      builder: (context, provider, child) {
        final currencyFormat = NumberFormat.simpleCurrency();
        final change = provider.percentageChange;
        final isPositive = change >= 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColourStyles.primaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColourStyles.borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sales Trends",
                style: TextStyles.sectionTitle(context).copyWith(
                  fontSize: 16,
                  color: ColourStyles.primaryColor_2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                currencyFormat.format(provider.totalForSelectedPeriod),
                style: TextStyles.valueText(context).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _getPeriodLabel(provider.selectedPeriod),
                    style: TextStyles.caption2(context),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  Text(
                    "${isPositive ? '+' : ''}${change.toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColourStyles.borderColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPeriodButton(context, provider, TrendPeriod.day, "D"),
                    _buildPeriodButton(context, provider, TrendPeriod.week, "W"),
                    _buildPeriodButton(context, provider, TrendPeriod.month, "M"),
                    _buildPeriodButton(context, provider, TrendPeriod.sixMonths, "6M"),
                    _buildPeriodButton(context, provider, TrendPeriod.year, "Y"),
                    _buildPeriodButton(context, provider, TrendPeriod.custom, "C"),
                  ],
                ),
              ),
              if (provider.selectedPeriod == TrendPeriod.custom) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateBox(
                        context,
                        "Start Date",
                        provider.customStartDate,
                        () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: provider.customStartDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            provider.setCustomRange(
                              date,
                              provider.customEndDate ?? DateTime.now(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateBox(
                        context,
                        "End Date",
                        provider.customEndDate,
                        () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: provider.customEndDate ?? DateTime.now(),
                            firstDate: provider.customStartDate ?? DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            provider.setCustomRange(
                              provider.customStartDate ?? DateTime.now(),
                              date,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TrendChartWidget(
                    spots: provider.chartSpots,
                    period: provider.selectedPeriod,
                    customStartDate: provider.customStartDate,
                    isMonthly: provider.isCustomRangeMonthly,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateBox(
    BuildContext context,
    String label,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ColourStyles.borderColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColourStyles.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: ColourStyles.captionColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? DateFormat('dd - MMM - yyyy').format(date)
                  : "Select",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    RevenueProvider provider,
    TrendPeriod period,
    String label,
  ) {
    final isSelected = provider.selectedPeriod == period;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (period == TrendPeriod.custom) {
            provider.setPeriod(period);
          } else {
            provider.setPeriod(period);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? ColourStyles.colorBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : ColourStyles.captionColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getPeriodLabel(TrendPeriod period) {
    switch (period) {
      case TrendPeriod.day:
        return "vs Yesterday";
      case TrendPeriod.week:
        return "This Week";
      case TrendPeriod.month:
        return "This Month";
      case TrendPeriod.sixMonths:
        return "Last 6 Months";
      case TrendPeriod.year:
        return "This Year";
      case TrendPeriod.custom:
        return "Custom Range";
    }
  }
}

