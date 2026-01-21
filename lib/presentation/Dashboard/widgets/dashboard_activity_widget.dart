import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class DashboardActivityWidget extends StatelessWidget {
  const DashboardActivityWidget({super.key});

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
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          children: List.generate(provider.dashboardActivity.length, (index) {
            final activity = provider.dashboardActivity[index];
            final double imageSize = _scale(context, 50);
            return Padding(
              padding: EdgeInsets.only(bottom: currentHeight * 0.015),
              child: Card(
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
                  child: Row(
                    children: [
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _scale(context, 8),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            _scale(context, 8),
                          ),
                          child: Image.asset(
                            activity.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: currentWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title!,
                              style: TextStyles.titleText(context),
                            ),
                            Text(
                              activity.product!,
                              style: TextStyles.activityCardText(context),
                            ),
                            Text(
                              activity.category!,
                              style: TextStyles.activityCardText(context),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${activity.unit}',
                            style: TextStyles.activityCardUnit(context)
                                .copyWith(
                                  color: activity.isPositive!
                                      ? ColourStyles.colorGreen
                                      : ColourStyles.colorRed,
                                ),
                          ),
                          Text(
                            activity.label!,
                            style: TextStyles.activityCardLabel(context),
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
