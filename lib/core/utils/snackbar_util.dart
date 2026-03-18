import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Utility class used to show SnackBars across the app
class SnackbarUtil {
  static void showSnackBar(BuildContext context, String message, bool isError) {
    // Remove any snackbar that is currently visible
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // Show a new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Red → error message
        // Green → success message
        backgroundColor: isError
            ? ColourStyles.colorRed
            : ColourStyles.colorGreen,
        // Makes snackbar float above the UI instead of sticking to bottom
        behavior: SnackBarBehavior.floating,
        // Snackbar display duration
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(15),
        // Content inside snackbar
        content: Row(
          children: [
            // Icon indicating success or error
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: ColourStyles.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                // Base text style from app theme
                style: TextStyles.primaryText(
                  context,
                ).copyWith(color: ColourStyles.primaryColor),
                // Limit message to two lines
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
