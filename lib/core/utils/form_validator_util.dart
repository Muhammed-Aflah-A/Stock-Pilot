class FormValidatorUtil {
  static String? validateName(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "Please enter $fieldName";
    if (val.length < 3) return "$fieldName must be at least 3 characters";
    if (val.length > 30) return "$fieldName must not exceed 30 characters";
    
    final nameRegex = RegExp(r"^[a-zA-Z]+(?:\s[a-zA-Z]+)*$");
    if (!nameRegex.hasMatch(val)) {
      return "Enter a valid $fieldName (letters only, no extra spaces)";
    }
    return null;
  }

  static String? validateShopName(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "Please enter your shop name";
    if (val.length < 3) return "Shop name must be at least 3 characters";
    if (val.length > 30) return "Shop name must not exceed 30 characters";
    
    final shopRegex = RegExp(
      r"^(?!.*\s\s)[a-zA-Z0-9](?:[a-zA-Z0-9\s'&#./,()-]*[a-zA-Z0-9.])?$",
    );
    if (!shopRegex.hasMatch(val)) {
      return "Invalid characters or extra spaces in shop name";
    }
    return null;
  }

  static String? validatePhone(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    if (val.contains(' ')) return "$fieldName cannot contain spaces";
    final phoneRegex = RegExp(r"^\+[1-9]\d{6,14}$");
    if (!phoneRegex.hasMatch(val)) {
      return "Format: (e.g. +911234567890)";
    }
    return null;
  }

  static String? validateEmail(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    if (val.length < 3) return "$fieldName must be at least 3 characters";
    if (val.length > 254) return "$fieldName must not exceed 254 characters";
    final gmailRegex = RegExp(r"^[a-z0-9.]+@gmail\.com$");
    if (!gmailRegex.hasMatch(val)) {
      return "Please enter a valid lowercase @gmail.com address";
    }
    return null;
  }

  static String? validateAddress(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    if (val.length < 30) return "$fieldName must be at least 30 characters";
    if (val.length > 100) return "$fieldName must not exceed 100 characters";
    
    final addressRegex = RegExp(r"^(?!.*\s\s)[a-zA-Z0-9\s,.\/#-]{30,100}$");
    if (!addressRegex.hasMatch(val)) {
      return "$fieldName contains invalid characters or extra spaces";
    }
    return null;
  }

  static String? validateProductName(String? value, String? fieldName) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return "Please enter the $fieldName";
    }
    
    if (!RegExp(r'^(?!.*\s\s).{3,30}$').hasMatch(value)) {
      return "$fieldName must be 3-30 characters with no extra spaces";
    }
    return null;
  }

  static String? validateProductDescription(String? value, String? fieldName) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName";
    }
    
    if (!RegExp(r'^(?!.*\s\s).{10,4000}$', dotAll: true).hasMatch(value)) {
      return "$fieldName must be 10–4000 characters with no extra spaces";
    }
    return null;
  }

  static String? validateProductfilter(String? value, String? fieldName) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }

  static String? validateRate(String? value, String? fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    if (RegExp(r'\s').hasMatch(value)) {
      return "$fieldName must not contain spaces";
    }
    if (value.startsWith('-')) {
      return "$fieldName must not be negative";
    }
    return null;
  }

  static String? validateCount(String? value, String? fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "$fieldName must be a whole number";
    }
    return null;
  }

  static String? validatefilter(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) {
      return "Please enter a $fieldName";
    }
    
    if (!RegExp(r'^(?!.*\s\s).{2,30}$').hasMatch(val)) {
      return "Invalid $fieldName (2-30 characters, no extra spaces)";
    }
    return null;
  }

  static String? validateDate(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) {
      return "Please select a $fieldName";
    }
    return null;
  }

  static String? validateItemQty(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "Required";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Invalid";
    final qty = int.parse(val);
    if (qty <= 0) return "Invalid";
    return null;
  }
}
