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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dashboard.dashboardCards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 4 ? 1.4 : 1.2,
          ),
          itemBuilder: (context, index) {
            final item = dashboard.dashboardCards[index];
            return Card(
              elevation: 3,
              color: ColourStyles.primaryColor_3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColourStyles.borderColor, width: 1),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.value ?? "",
                      style: ValueStyleUtil.getValueStyle(
                        context,
                        item.title ?? "",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
