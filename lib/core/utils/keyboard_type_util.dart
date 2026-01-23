import 'package:flutter/material.dart';

class KeyboardTypeUtil {
  static TextInputType? getKeyboardType(String type) {
    switch (type.toLowerCase()) {
      case "name":
        return TextInputType.name;
      case "email":
        return TextInputType.emailAddress;
      case 'personal number':
        return TextInputType.phone;
      case 'shop name':
        return TextInputType.text;
      case 'shop address':
        return TextInputType.multiline;
      case 'shop number':
        return TextInputType.phone;
      default:
        return null;
    }
  }
}
