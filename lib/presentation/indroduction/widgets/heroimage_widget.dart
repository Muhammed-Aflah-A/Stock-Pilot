import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class HeroimageWidget extends StatelessWidget {
  final double heightFactor;
  final String imagePath;

  const HeroimageWidget({
    super.key,
    required this.heightFactor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenSize.width * 0.8,
        maxHeight: screenSize.height * heightFactor,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported,
            size: screenSize.width * 0.2,
            color: ColourStyles.iconColor,
          );
        },
      ),
    );
  }
}
