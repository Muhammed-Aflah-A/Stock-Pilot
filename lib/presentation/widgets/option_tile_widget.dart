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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(12.0, 20.0);
    final iconSize = (size.width * 0.06).clamp(20.0, 28.0);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(icon, size: iconSize, color: ColourStyles.primaryColor_2),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: TextStyles.primaryText(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
