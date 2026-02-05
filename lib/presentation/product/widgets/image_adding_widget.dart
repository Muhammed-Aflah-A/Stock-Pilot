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
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();
    final images = provider.productImages.whereType<File>().toList();
    final itemCount = images.length < 4 ? images.length + 1 : 4;
    return Center(
      child: Wrap(
        spacing: currentWidth * 0.03,
        runSpacing: currentWidth * 0.03,
        alignment: WrapAlignment.center,
        children: List.generate(itemCount, (index) {
          final File? image = index < images.length ? images[index] : null;
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => PermissionDialog(
                  provider: context.read<ProductProvider>(),
                  index: index,
                ),
              );
            },
            child: Container(
              width: currentWidth * 0.43,
              height: currentWidth * 0.43,
              decoration: BoxDecoration(
                color: ColourStyles.primaryColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_sharp,
                          size: currentWidth * 0.08,
                        ),
                        const SizedBox(height: 4),
                        const Text("Add Photo"),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                            onTap: () => provider.removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: ColourStyles.primaryColor_2,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
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
  }
}
