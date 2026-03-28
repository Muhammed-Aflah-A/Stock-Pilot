// Utility class containing reusable form validation methods
class FormValidatorUtil {
  // Validates a user's name.
  static String? validateName(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    // Empty check
    if (val.isEmpty) return "Please enter $fieldName";
    // Minimum length check
    if (val.length < 3) return "$fieldName must be at least 3 characters";
    // Only letters and spaces allowed
    final nameRegex = RegExp(r"^[a-zA-Z]+(?:\s[a-zA-Z]+)*$");
    if (!nameRegex.hasMatch(val)) {
      return "Enter a valid $fieldName (letters only)";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(val)) {
      return "Remove extra spaces between words";
    }
    return null;
  }

  // Validates shop name.
  static String? validateShopName(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    // Empty check
    if (val.isEmpty) return "Please enter your shop name";
    // Minimum length check
    if (val.length < 3) return "Shop name must be at least 3 characters";
    // Allows letters, numbers and safe punctuation used in business names
    final shopRegex = RegExp(
      r"^[a-zA-Z0-9](?:[a-zA-Z0-9\s'&#./,()-]*[a-zA-Z0-9.])?$",
    );
    if (!shopRegex.hasMatch(val)) {
      return "Invalid characters in shop name";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(val)) {
      return "Remove extra spaces between words";
    }
    return null;
  }

  // Validates international phone numbers.
  static String? validatePhone(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    // Empty check
    if (val.isEmpty) return "$fieldName is required";
    // Phone numbers should not contain spaces
    if (val.contains(' ')) return "$fieldName cannot contain spaces";
    // International phone format
    final phoneRegex = RegExp(r"^\+[1-9]\d{6,14}$");
    if (!phoneRegex.hasMatch(val)) {
      return "Format: (e.g. +919876543210)";
    }
    return null;
  }

  // Validates Gmail addresses.
  static String? validateEmail(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    // Empty check
    if (val.isEmpty) return "$fieldName is required";
    // Gmail-only validation
    final gmailRegex = RegExp(r"^[a-z0-9.]+@gmail\.com$");
    if (!gmailRegex.hasMatch(val)) {
      return "Please enter a valid lowercase @gmail.com address";
    }
    return null;
  }

  // Validates shop address.
  static String? validateAddress(String? value, String? fieldName) {
    final val = value?.trim() ?? '';
    // Empty check
    if (val.isEmpty) return "$fieldName is required";
    // Minimum length check
    if (val.length < 10) return "$fieldName must be at least 10 characters";
    // Allowed address characters
    final addressRegex = RegExp(r"^[a-zA-Z0-9\s,.\/#-]{10,250}$");
    if (!addressRegex.hasMatch(val)) {
      return "$fieldName contains invalid special characters";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(val)) return "No multiple spaces allowed";
    return null;
  }

  static String? validateProductName(String? value, String? fieldName) {
    value = value?.trim();
    // Empty check
    if (value == null || value.isEmpty) {
      return "Please enter the $fieldName";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(value)) {
      return "$fieldName cannot contain multiple spaces together";
    }
    // Minimum and maximum length check
    if (!RegExp(r'^.{3,25}$').hasMatch(value)) {
      return "$fieldName must be between 3 and 25 characters";
    }
    return null;
  }

  static String? validateProductDescription(String? value, String? fieldName) {
    value = value?.trim();
    // Empty check
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName";
    }
    // Minimum and maximum length check
    if (!RegExp(r'^.{10,500}$').hasMatch(value)) {
      return "$fieldName must be 10–500 characters";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(value)) {
      return "$fieldName cannot contain multiple spaces together";
    }
    return null;
  }

  static String? validateProductfilter(String? value, String? fieldName) {
    value = value?.trim();
    // Empty check
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }

  // Validates product price/rate.
  static String? validateRate(String? value, String? fieldName) {
    // Empty check
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    // Prevent spaces
    if (RegExp(r'\s').hasMatch(value)) {
      return "$fieldName must not contain spaces";
    }
    // Prevent negative number
    if (value.startsWith('-')) {
      return "$fieldName must not be negative";
    }
    return null;
  }

  // Validates product quantity/count.
  static String? validateCount(String? value, String? fieldName) {
    // Empty check
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    // Only whole numbers allowed.
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "$fieldName must be a whole number";
    }
    return null;
  }

  // Generic text filter validator.
  static String? validatefilter(String? value, String? fieldName) {
    // Empty check
    final val = value?.trim() ?? '';
    if (val.isEmpty) {
      return "Please enter a $fieldName";
    }
    // Minimum length check
    if (val.length < 2) {
      return "$fieldName is too short";
    }
    // Maximum length check
    if (val.length > 30) {
      return "$fieldName is too long (max 30)";
    }
    // Prevent multiple spaces
    if (RegExp(r'\s{2,}').hasMatch(val)) {
      return "Remove extra spaces from $fieldName";
    }
    return null;
  }

  // Date validator.
  static String? validateDate(String? value, String? fieldName) {
    // Empty check
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
