import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class HeroImageWidget extends StatelessWidget {
  final double heightFactor;
  final String imagePath;

  const HeroImageWidget({
    super.key,
    required this.heightFactor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * heightFactor,
        maxWidth: size.width * 0.8,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported,
          size: size.width * 0.2,
          color: ColourStyles.iconColor,
        ),
      ),
    );
  }
}
