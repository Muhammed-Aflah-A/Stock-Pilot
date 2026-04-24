import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/image_preview_screen.dart';
import 'package:stock_pilot/presentation/product/widgets/product_detail_row_widget.dart';

class HistoryDetailPage extends StatelessWidget {
  final DasboardActivity activity;

  const HistoryDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(16.0, 28.0);
    final spacing = (size.height * 0.025).clamp(16.0, 28.0);

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Activity Details",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showImagePreview(context),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColourStyles.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: 'history_image_${activity.date.hashCode}_${activity.product.hashCode}',
                          child: Image(
                            image: ImageUtil.getProductImage(activity.image),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: ColourStyles.primaryColor_3,
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 50,
                                  color: ColourStyles.colorGrey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                  SizedBox(height: spacing),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(horizontalPadding),
                    decoration: BoxDecoration(
                      color: ColourStyles.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColourStyles.shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.product ?? "Unknown Product",
                          style: TextStyles.dialogueHeading(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activity.category ?? "General",
                          style: TextStyles.caption(context),
                        ),

                        DetailRowWidget(
                          label: 'Brand',
                          value: activity.brand ?? "Unknown",
                          showDivider: true,
                        ),
                        DetailRowWidget(
                          label: 'Action',
                          value: activity.title ?? "",
                          showDivider: true,
                        ),
                        DetailRowWidget(
                          label: 'Quantity Change',
                          value:
                              '${activity.isPositive == true ? "+" : "-"}${NumberFormatterUtil.format(activity.unit ?? 0)} ${activity.label}',
                          showDivider: true,
                          valueColor:
                              (activity.isPositive == true ||
                                  activity.title == 'Item Sold')
                              ? ColourStyles.colorGreen
                              : ColourStyles.colorRed,
                        ),
                        DetailRowWidget(
                          label: 'Date',
                          value: activity.date ?? "",
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  if (activity.title == 'Item Sold' &&
                      activity.customerName != null) ...[
                    SizedBox(height: spacing),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColourStyles.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: TextStyles.cardHeading(context),
                          ),
                          const SizedBox(height: 16),
                          DetailRowWidget(
                            label: 'Name',
                            value: activity.customerName ?? "Guest",
                            showDivider: true,
                          ),
                          DetailRowWidget(
                            label: 'Phone',
                            value: activity.customerNumber ?? "Not provided",
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    if (activity.image != null && activity.image!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreviewScreen(
            imagePath: activity.image!,
            heroTag: 'history_image_${activity.date.hashCode}_${activity.product.hashCode}',
            title: "Product Image",
          ),
        ),
      );
    }
  }
}
