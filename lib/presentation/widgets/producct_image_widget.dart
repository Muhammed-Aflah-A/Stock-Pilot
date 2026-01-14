import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/productimage_placeholder.dart';

class ProductImageWidget extends StatefulWidget {
  final List<String> images;
  final double? height;

  const ProductImageWidget({super.key, required this.images, this.height});

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final displayImages = widget.images.where((img) => img.isNotEmpty).toList();
    final effectiveHeight = widget.height ?? currentHeight * 0.35;

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: ColourStyles.colorgrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          displayImages.isNotEmpty
              ? PageView.builder(
                  itemCount: displayImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(displayImages[index]),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ProductimagePlaceholder();
                        },
                      ),
                    );
                  },
                )
              : ProductimagePlaceholder(),
          if (displayImages.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  displayImages.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? ColourStyles.primaryColor
                          : ColourStyles.colorgrey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
