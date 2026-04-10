import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Reusable tile widget used for options like Camera / Library
class OptionTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  final Color? color;

  const OptionTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: color ?? ColourStyles.primaryColor_2,
              ),
              SizedBox(width: 16),
              Expanded(
                // Title label
                child: Text(
                  title,
                  style: TextStyles.primaryText(context).copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
