import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/image_preview_screen.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog_widget.dart';

class ImageAddingWidget extends StatelessWidget {
  const ImageAddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProvider, List<String?>>(
      selector: (_, provider) => provider.productImages,
      builder: (context, images, _) {
        final nonEmptyImages = images.where((img) => img != null).toList();
        return LayoutBuilder(
          builder: (context, constraints) {
            final tileSize = (constraints.maxWidth / 2 - 12).clamp(
              120.0,
              200.0,
            );
            final itemCount =
                nonEmptyImages.length < 4 ? nonEmptyImages.length + 1 : 4;
            return Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(itemCount, (index) {
                  final String? imagePath = index < nonEmptyImages.length
                      ? nonEmptyImages[index]
                      : null;
                  return GestureDetector(
                    onTap: () {
                      if (imagePath == null) {
                        showDialog(
                          context: context,
                          builder: (_) => PermissionDialog(
                            provider: context.read<ProductProvider>(),
                            index: index,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewScreen(
                              imagePath: imagePath,
                              title: "Product Image",
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: tileSize,
                      height: tileSize,
                      decoration: BoxDecoration(
                        color: ColourStyles.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColourStyles.primaryColor_2,
                          width: 2,
                        ),
                      ),
                      child: imagePath == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 30,
                                ),
                                SizedBox(height: 6),
                                Text("Add Photo"),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: Hero(
                                    tag: imagePath,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: ImageUtil.getProductImage(
                                          imagePath,
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 30,
                                                ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      context
                                          .read<ProductProvider>()
                                          .removeImage(index: index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: ColourStyles.primaryColor_2,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: ColourStyles.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}

