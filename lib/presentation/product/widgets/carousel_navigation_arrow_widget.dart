import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';



class CarouselNavigationArrowWidget extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final VoidCallback onPressed;

  const CarouselNavigationArrowWidget({
    super.key,
    required this.alignment,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: Icon(icon, color: ColourStyles.primaryColor, size: 16),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

