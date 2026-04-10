import 'package:flutter/material.dart';

class DialogUtil {
  /// Returns a standard width for dialogs across the app
  /// to ensure visual consistency.
  static double getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // 85% of screen width, clamped between 280 and 420 pixels
    return (screenWidth * 0.85).clamp(280.0, 420.0);
  }
}
