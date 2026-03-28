import 'package:flutter/material.dart';

// Utility class used to decide which keyboard should appear
class KeyboardTypeUtil {
  // Returns the correct keyboard type based on the field type
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
      // Default keyboard if type does not match anything
      default:
        return TextInputType.text;
    }
  }
}
