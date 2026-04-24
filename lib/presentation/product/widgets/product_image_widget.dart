import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/presentation/product/widgets/product_image_placeholder.dart';
import 'package:stock_pilot/presentation/widgets/image_preview_screen.dart';
import 'package:stock_pilot/presentation/product/widgets/carousel_navigation_arrow_widget.dart';

class ProductImageWidget extends StatefulWidget {
  final List<String> images;
  final double? height;

  const ProductImageWidget({super.key, required this.images, this.height});

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  late final PageController _pageController;
  int _localIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayImages = widget.images.where((img) => img.isNotEmpty).toList();
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          displayImages.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: displayImages.length,
                  onPageChanged: (index) {
                    setState(() => _localIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final String imagePath = displayImages[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewScreen(
                              imagePath: imagePath,
                              heroTag:
                                  'product_detail_image_${imagePath.hashCode}',
                              title: "Product Image",
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'product_detail_image_${imagePath.hashCode}',
                        child: Image(
                          image: ImageUtil.getProductImage(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const ProductImagePlaceholder(),
                        ),
                      ),
                    );
                  },
                )
              : const ProductImagePlaceholder(),
          if (displayImages.length > 1) ...[
            if (_localIndex > 0)
              CarouselNavigationArrowWidget(
                alignment: Alignment.centerLeft,
                icon: Icons.arrow_back_ios_new,
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            if (_localIndex < displayImages.length - 1)
              CarouselNavigationArrowWidget(
                alignment: Alignment.centerRight,
                icon: Icons.arrow_forward_ios,
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
          ],
          if (displayImages.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  displayImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _localIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _localIndex == index
                          ? ColourStyles.primaryColor
                          : ColourStyles.colorGrey,
                    ),
                  ),
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}
