import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/value_style_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({super.key});

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.sizeOf(context).height;
    final currentWidth = MediaQuery.sizeOf(context).width;
    final dashboardProvider = context.watch<DashboardProvider>();
    int crossAxisCount = currentWidth > 600 ? 3 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: currentWidth * 0.03,
        mainAxisSpacing: currentHeight * 0.015,
        childAspectRatio: currentWidth > 600 ? 1.5 : 1.3,
      ),
      itemCount: dashboardProvider.dashboardCards.length,
      itemBuilder: (context, index) {
        final item = dashboardProvider.dashboardCards[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: ColourStyles.cardborderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_scale(context, 10)),
          ),
          color: ColourStyles.primaryColor_3,
          child: Padding(
            padding: EdgeInsets.all(_scale(context, 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title!,
                  style: TextStyles.titleText(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: currentHeight * 0.01),
                Text(
                  item.value!,
                  style: ValueStyleUtil.getValueStyle(context, item.title!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
