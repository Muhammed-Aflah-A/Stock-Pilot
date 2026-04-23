import 'package:flutter/material.dart';

class DialogUtil {
  static double getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return (screenWidth * 0.85).clamp(280.0, 420.0);
  }
}
