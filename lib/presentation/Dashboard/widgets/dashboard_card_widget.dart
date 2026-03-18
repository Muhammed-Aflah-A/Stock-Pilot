import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/value_style_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

// Widget that displays dashboard cards in a grid layout
class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    // Listen to provider so UI updates when dashboard data changes
    final dashboard = context.watch<DashboardProvider>();
    // Default grid columns for small screens
    int columns = 2;
    // Increase columns based on screen width (responsive layout)
    if (width >= 900) {
      columns = 4;
    } else if (width >= 600) {
      columns = 3;
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Number of cards to display
      itemCount: dashboard.dashboardCards.length,
      // Grid layout configuration
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Number of columns
        crossAxisCount: columns,
        // Horizontal space between cards
        crossAxisSpacing: 16,
        // Vertical space between cards
        mainAxisSpacing: 16,
        // Card shape ratio
        childAspectRatio: width >= 900 ? 1.6 : 1.35,
      ),
      // Builds each card
      itemBuilder: (context, index) {
        // Get card data from provider
        final item = dashboard.dashboardCards[index];
        return Card(
          // Shadow depth
          elevation: 3,
          color: ColourStyles.primaryColor_3,
          // Card border and shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: ColourStyles.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dashboard card title
                Text(
                  item.title ?? "",
                  style: TextStyles.titleText(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                // Dashboard card value
                Text(
                  item.value ?? "",
                  style: ValueStyleUtil.getValueStyle(
                    context,
                    item.title ?? "",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
