import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/widgets/product_image_placeholder.dart';

// Widget that displays product images in a carousel
class ProductImageWidget extends StatefulWidget {
  final List<String> images;
  final double? height;

  const ProductImageWidget({super.key, required this.images, this.height});

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  // Controller used to control the PageView (carousel)
  late final PageController _pageController;
  int _localIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize PageController when widget is created
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Remove empty image paths from the list
    final displayImages = widget.images.where((img) => img.isNotEmpty).toList();
    final effectiveHeight =
        widget.height ?? MediaQuery.of(context).size.height * 0.35;
    return Container(
      height: effectiveHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          /// IMAGE CAROUSEL
          displayImages.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  // Total number of images
                  itemCount: displayImages.length,
                  // Update the current index when page changes
                  onPageChanged: (index) {
                    setState(() => _localIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(displayImages[index]),
                      fit: BoxFit.cover,
                      // If image fails to load, show placeholder
                      errorBuilder: (context, error, stackTrace) =>
                          const ProductImagePlaceholder(),
                    );
                  },
                )
              // Show placeholder when there are no images
              : const ProductImagePlaceholder(),
          // NAVIGATION ARROWS (only if multiple images exist)
          if (displayImages.length > 1) ...[
            // Left arrow (shown only if not on first image)
            if (_localIndex > 0)
              _buildArrow(
                alignment: Alignment.centerLeft,
                icon: Icons.arrow_back_ios_new,
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),

            // Right arrow (shown only if not on last image)
            if (_localIndex < displayImages.length - 1)
              _buildArrow(
                alignment: Alignment.centerRight,
                icon: Icons.arrow_forward_ios,
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
          ],
          // PAGE INDICATOR DOTS
          // Shows which image is currently active
          if (displayImages.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Create dots equal to number of images
                children: List.generate(
                  displayImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    // Active dot is larger
                    width: _localIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      // Active dot uses primary color
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
    );
  }

  // Small helper widget used for carousel navigation arrows
  Widget _buildArrow({
    required Alignment alignment,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 16),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
