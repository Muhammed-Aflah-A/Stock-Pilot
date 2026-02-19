import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';

class ImageAddingWidget extends StatelessWidget {
  const ImageAddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProvider, List<File>>(
      selector: (_, provider) =>
          provider.productImages.whereType<File>().toList(),
      builder: (context, images, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final tileSize = (maxWidth / 2 - 12).clamp(120.0, 200.0);
            final itemCount = images.length < 4 ? images.length + 1 : 4;
            return Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(itemCount, (index) {
                  final File? image = index < images.length
                      ? images[index]
                      : null;
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => PermissionDialog(
                          provider: context.read<ProductProvider>(),
                          index: index,
                        ),
                      );
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
                      child: image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_photo_alternate_rounded, size: 30),
                                SizedBox(height: 6),
                                Text("Add Photo"),
                              ],
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<ProductProvider>()
                                        .removeImage(index),
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
