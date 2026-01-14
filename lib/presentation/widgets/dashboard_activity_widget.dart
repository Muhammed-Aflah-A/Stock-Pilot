import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardActivityWidget extends StatelessWidget {
  const DashboardActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          children: List.generate(provider.dashboardActivity.length, (index) {
            final activity = provider.dashboardActivity[index];
            return Padding(
              padding: EdgeInsets.only(bottom: currentHeigth * 0.01),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: ColourStyles.cardborderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: ColourStyles.primaryColor_3,
                child: Padding(
                  padding: EdgeInsets.all(currentHeigth * 0.015),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            activity.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: currentWidth * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title!,
                              style: TextStyles.primaryText_2,
                            ),
                            Text(
                              activity.product!,
                              style: TextStyles.recentCardtext,
                            ),
                            Text(
                              activity.category!,
                              style: TextStyles.recentCardtext,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${activity.unit}',
                            style: TextStyles.recentCardtext_2.copyWith(
                              color: activity.isPositive!
                                  ? ColourStyles.colorGreen
                                  : ColourStyles.colorRed,
                            ),
                          ),
                          Text(
                            activity.label!,
                            style: TextStyles.recentCardtext_3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
