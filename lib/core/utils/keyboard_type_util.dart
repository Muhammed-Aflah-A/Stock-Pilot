import 'package:flutter/material.dart';

class KeyboardTypeUtil {
  static TextInputType getKeyboardType(String type) {
    switch (type.toLowerCase()) {
      case "name":
        return TextInputType.name;
      case "email":
        return TextInputType.emailAddress;
      case 'phone number':
      case 'personal number':
      case 'shop number':
        return TextInputType.phone;
      case 'shop name':
        return TextInputType.text;
      case 'shop address':
      case 'address':
        return TextInputType.streetAddress;
      case 'product name':
        return TextInputType.name;
      case 'product description':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}
