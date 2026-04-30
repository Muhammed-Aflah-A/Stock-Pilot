import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/value_style_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int columns = 2;
        if (availableWidth >= 800) {
          columns = 4;
        } else if (availableWidth >= 500) {
          columns = 3;
        }

        final List<Widget> rows = [];
        for (int i = 0; i < dashboard.dashboardCards.length; i += columns) {
          final rowItems = dashboard.dashboardCards
              .skip(i)
              .take(columns)
              .toList();

          final List<Widget> rowChildren = [];
          for (int j = 0; j < columns; j++) {
            if (j < rowItems.length) {
              final item = rowItems[j];
              rowChildren.add(
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: ColourStyles.primaryColor_3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: ColourStyles.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title ?? "",
                            style: TextStyles.titleText(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.value ?? "",
                            style: ValueStyleUtil.getValueStyle(
                              context,
                              item.title ?? "",
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              rowChildren.add(const Expanded(child: SizedBox.shrink()));
            }

            if (j < columns - 1) {
              rowChildren.add(const SizedBox(width: 16));
            }
          }

          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          );
        }

        return Column(
          children: rows
              .map(
                (row) => Padding(
                  padding: EdgeInsets.only(bottom: row == rows.last ? 0 : 16.0),
                  child: row,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
