import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final dashboardProvider = context.watch<DashboardProvider>();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: currentWidth * 0.02,
        mainAxisSpacing: currentHeigth * 0.01,
        childAspectRatio: currentHeigth * 0.002,
      ),
      itemCount: dashboardProvider.dashboardCards.length,
      itemBuilder: (context, index) {
        final item = dashboardProvider.dashboardCards[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColourStyles.cardborderColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          color: ColourStyles.primaryColor_3,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: currentHeigth * 0.01,
              horizontal: currentWidth * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.title!, style: TextStyles.primaryText_2),
                SizedBox(height: currentHeigth * 0.005),
                Text(item.value!, style: item.valueStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}
