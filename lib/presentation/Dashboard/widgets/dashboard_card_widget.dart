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
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final dashboardProvider = context.watch<DashboardProvider>();
    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;
    final crossSpacing = (width * 0.04).clamp(12.0, 24.0);
    final mainSpacing = (size.height * 0.02).clamp(12.0, 20.0);
    final borderRadius = 14.0;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboardProvider.dashboardCards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossSpacing,
        mainAxisSpacing: mainSpacing,
        childAspectRatio: width >= 900 ? 1.6 : 1.35,
      ),
      itemBuilder: (context, index) {
        final item = dashboardProvider.dashboardCards[index];
        return Card(
          elevation: 3,
          color: ColourStyles.primaryColor_3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(
              color: ColourStyles.cardborderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 10),
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
