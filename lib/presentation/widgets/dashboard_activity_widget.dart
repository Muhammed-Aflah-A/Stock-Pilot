import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardActivityWidget extends StatelessWidget {
  const DashboardActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Expanded(
      child: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: h * 0.01),
            itemCount: provider.dashboardActivity.length,
            itemBuilder: (context, index) {
              final activity = provider.dashboardActivity[index];
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: ColourStyles.cardborderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: ColourStyles.primaryColor_3,
                child: Padding(
                  padding: EdgeInsets.all(h * 0.016),
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
                      SizedBox(width: w * 0.03),
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              activity.category!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${activity.unit}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: activity.isPositive!
                                  ? ColourStyles.colorGreen
                                  : ColourStyles.colorRed,
                            ),
                          ),
                          Text(
                            activity.label!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
