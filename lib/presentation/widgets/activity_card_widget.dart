import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';

class ActivityCardWidget extends StatelessWidget {
  final DasboardActivity activity;

  const ActivityCardWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final imageSize = width < 360 ? 45.0 : 50.0;
    final borderRadius = BorderRadius.circular(8);
    final sign = activity.isPositive == true ? "+" : "-";

    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.015),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ColourStyles.borderColor, width: 1),
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
                    '$sign${NumberFormatterUtil.format(activity.unit ?? 0)}',
                    style: TextStyles.activityCardUnit(context).copyWith(
                      color:
                          (activity.isPositive == true ||
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
  }
}
