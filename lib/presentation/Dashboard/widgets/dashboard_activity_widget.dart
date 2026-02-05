// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stock_pilot/core/theme/colours_styles.dart';
// import 'package:stock_pilot/core/theme/text_styles.dart';
// import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
// import 'package:stock_pilot/core/assets/app_images.dart';

// class DashboardActivityWidget extends StatelessWidget {
//   const DashboardActivityWidget({super.key});

//   double _scale(BuildContext context, double size) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     if (screenWidth < 360) return size * 0.9;
//     if (screenWidth < 600) return size * 1.0;
//     return size * 1.2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentHeight = MediaQuery.sizeOf(context).height;
//     final currentWidth = MediaQuery.sizeOf(context).width;

//     return Consumer<DashboardProvider>(
//       builder: (context, provider, _) {
//         return Column(
//           children: List.generate(provider.dashboardActivity.length, (index) {
//             final activity = provider.dashboardActivity[index];
//             final double imageSize = _scale(context, 50);

//             return Padding(
//               padding: EdgeInsets.only(bottom: currentHeight * 0.015),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(
//                     color: ColourStyles.cardborderColor,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(_scale(context, 10)),
//                 ),
//                 color: ColourStyles.primaryColor_3,
//                 child: Padding(
//                   padding: EdgeInsets.all(_scale(context, 12)),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: imageSize,
//                         height: imageSize,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             _scale(context, 8),
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(
//                             _scale(context, 8),
//                           ),
//                           child: Image.file(
//                             File(activity.image!),
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Image.asset(
//                                 AppImages.productImage1,
//                                 fit: BoxFit.cover,
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: currentWidth * 0.04),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               activity.title!,
//                               style: TextStyles.titleText(context),
//                             ),
//                             Text(
//                               activity.product!,
//                               style: TextStyles.activityCardText(context),
//                             ),
//                             Text(
//                               activity.category!,
//                               style: TextStyles.activityCardText(context),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             '${activity.unit}',
//                             style: TextStyles.activityCardUnit(context)
//                                 .copyWith(
//                                   color: activity.isPositive!
//                                       ? ColourStyles.colorGreen
//                                       : ColourStyles.colorRed,
//                                 ),
//                           ),
//                           Text(
//                             activity.label!,
//                             style: TextStyles.activityCardLabel(context),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';

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
        final activities = provider.recentActivities;
        if (activities.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: currentHeight * 0.05),
              child: Text(
                "No recent activities found",
                style: TextStyles.primaryText(context),
              ),
            ),
          );
        }
        return Column(
          children: List.generate(activities.length, (index) {
            final activity = activities[index];
            final double imageSize = _scale(context, 50);
            return Padding(
              padding: EdgeInsets.only(bottom: currentHeight * 0.015),
              child: Card(
                elevation: 2,
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
                          child:
                              activity.image != null &&
                                  activity.image!.isNotEmpty
                              ? Image.file(
                                  File(activity.image!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                        AppImages.productImage1,
                                        fit: BoxFit.cover,
                                      ),
                                )
                              : Image.asset(
                                  AppImages.productImage1,
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
                              style: TextStyles.titleText(context).copyWith(
                                fontSize: _scale(context, 14),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              activity.product!,
                              style: TextStyles.activityCardText(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              activity.category!,
                              style: TextStyles.activityCardText(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${activity.isPositive == true ? "+" : "-"}${activity.unit}',
                            style: TextStyles.activityCardUnit(context)
                                .copyWith(
                                  color: activity.isPositive == true
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
