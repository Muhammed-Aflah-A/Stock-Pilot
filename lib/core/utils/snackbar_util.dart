import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class SnackbarUtil {
  static double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
    return size * 1.2;
  }

  static void showSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? ColourStyles.colorRed
            : ColourStyles.colorGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_scale(context, 12)),
        ),
        margin: EdgeInsets.all(_scale(context, 15)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: ColourStyles.primaryColor,
              size: _scale(context, 20),
            ),
            SizedBox(width: _scale(context, 12)),
            Text(
              message,
              style: TextStyles.primaryText(context).copyWith(
                color: ColourStyles.primaryColor,
                fontSize: _scale(context, 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
