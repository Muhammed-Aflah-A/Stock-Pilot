import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/core/utils/image_util.dart';

// Widget that shows latest activity in dashboard screen
class DashboardActivityWidget extends StatelessWidget {
  const DashboardActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final imageSize = width < 360 ? 45.0 : 50.0;
    final borderRadius = BorderRadius.circular(8);
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final activities = provider.recentActivities;
        // Show message when there are no activities
        if (activities.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Center(
              child: Text(
                "No recent activities found",
                style: TextStyles.primaryText(context),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            // Decide signs + or -
            final sign = activity.isPositive == true ? "+" : "-";
            return Padding(
              padding: EdgeInsets.only(bottom: height * 0.015),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: ColourStyles.borderColor,
                    width: 1,
                  ),
                  borderRadius: borderRadius,
                ),
                color: ColourStyles.primaryColor_3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: borderRadius,
                        child: SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: Image(
                            image: ImageUtil.getProductImage(activity.image),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(AppImages.productImage1);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      // Activity Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title ?? "",
                              style: TextStyles.titleText(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              activity.product ?? "",
                              style: TextStyles.activityCardText(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              activity.date ?? "",
                              style: TextStyles.activityCardText(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Unit change info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$sign${activity.unit}',
                            style: TextStyles.activityCardUnit(context)
                                .copyWith(
                                  color: (activity.isPositive == true ||
                                          activity.title == 'Item Sold')
                                      ? ColourStyles.colorGreen
                                      : ColourStyles.colorRed,
                                ),
                          ),
                          Text(
                            activity.label ?? "",
                            style: TextStyles.activityCardLabel(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
