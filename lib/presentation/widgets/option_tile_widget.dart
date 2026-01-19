import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class OptionTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const OptionTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: _scale(context, 24),
        color: ColourStyles.primaryColor_2,
      ),
      title: Text(title, style: TextStyles.primaryText(context)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: _scale(context, 16)),
    );
  }
}
