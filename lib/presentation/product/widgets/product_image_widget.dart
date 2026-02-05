import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/productimage_placeholder.dart';

class ProductImageWidget extends StatefulWidget {
  final List<String> images;
  final double? height;

  const ProductImageWidget({super.key, required this.images, this.height});

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  late PageController _pageController;
  int _localIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final provider = context.read<ProductProvider>();
    final displayImages = widget.images.where((img) => img.isNotEmpty).toList();
    final effectiveHeight = widget.height ?? currentHeight * 0.35;

    return Container(
      height: effectiveHeight,
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
                    provider.updateCarouselIndex(index);
                  },
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(displayImages[index]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ProductimagePlaceholder(),
                    );
                  },
                )
              : const ProductimagePlaceholder(),
          if (displayImages.length > 1) ...[
            if (_localIndex > 0)
              _buildArrow(
                alignment: Alignment.centerLeft,
                icon: Icons.arrow_back_ios_new,
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
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
    );
  }

  Widget _buildArrow({
    required Alignment alignment,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
