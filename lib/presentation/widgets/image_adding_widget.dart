import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';

class ImageAddingWidget extends StatelessWidget {
  const ImageAddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();
    final filledCount = provider.productImages
        .where((img) => img != null)
        .length;
    final itemCount = filledCount < 4 ? filledCount + 1 : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: currentWidth * 0.03,
        mainAxisSpacing: currentHeigth * 0.02,
        childAspectRatio: currentHeigth * 0.0015,
      ),
      itemBuilder: (context, index) {
        final image = index < provider.productImages.length
            ? provider.productImages[index]
            : null;

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return PermissionDialog(
                  provider: context.read<ProductProvider>(),
                  index: index,
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColourStyles.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColourStyles.primaryColor_2, width: 2),
            ),
            child: image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_sharp),
                      SizedBox(height: 4),
                      Text("Add Photo"),
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
                          onTap: () {
                            context.read<ProductProvider>().removeImage(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
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
      },
    );
  }
}
