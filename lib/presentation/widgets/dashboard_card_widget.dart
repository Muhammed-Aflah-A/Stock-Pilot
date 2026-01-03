import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final dashboardProvider = context.watch<DashboardProvider>();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1.7,
      ),
      itemCount: dashboardProvider.dashboardCards.length,
      itemBuilder: (context, index) {
        final item = dashboardProvider.dashboardCards[index];
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColourStyles.cardborderColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          color: ColourStyles.primaryColor_3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.title!, style: TextStyles.primaryText_2),
                SizedBox(height: h * 0.008),
                Text(item.value!, style: item.valueStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}
