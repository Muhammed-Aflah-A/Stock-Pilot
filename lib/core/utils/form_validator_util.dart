class FormValidatorUtil {
  static String? validateName(String? value, String fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "Please enter $fieldName";
    if (val.length < 3) return "$fieldName must be at least 3 characters";
    final nameRegex = RegExp(r"^[a-zA-Z]+(?:\s[a-zA-Z]+)*$");
    if (!nameRegex.hasMatch(val)) {
      return "Enter a valid $fieldName (letters only)";
    }
    return null;
  }

  static String? validateShopName(String? value, String fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "Please enter your shop name";
    if (val.length < 3) return "Shop name must be at least 3 characters";
    final shopRegex = RegExp(
      r"^[a-zA-Z0-9](?:[a-zA-Z0-9\s'&#./,()-]*[a-zA-Z0-9.])?$",
    );
    if (!shopRegex.hasMatch(val)) {
      return "Invalid characters in shop name";
    }
    if (RegExp(r'\s{2,}').hasMatch(val)) {
      return "Remove extra spaces between words";
    }
    return null;
  }

  static String? validatePhone(String? value, String fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    if (val.contains(' ')) return "$fieldName cannot contain spaces";
    final phoneRegex = RegExp(r"^\+[1-9]\d{6,14}$");
    if (!phoneRegex.hasMatch(val)) {
      return "Format: +[CountryCode][Number] (e.g. +919876543210)";
    }
    return null;
  }

  static String? validateEmail(String? value, String fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    final gmailRegex = RegExp(r"^[a-z0-9.]+@gmail\.com$");
    if (!gmailRegex.hasMatch(val)) {
      return "Please enter a valid lowercase @gmail.com address";
    }
    return null;
  }

  static String? validateAddress(String? value, String fieldName) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return "$fieldName is required";
    if (val.length < 10) return "$fieldName must be at least 10 characters";
    final addressRegex = RegExp(r"^[a-zA-Z0-9\s,.\/#-]{10,250}$");
    if (!addressRegex.hasMatch(val)) {
      return "$fieldName contains invalid special characters";
    }
    if (RegExp(r'\s{2,}').hasMatch(val)) return "No multiple spaces allowed";
    return null;
  }
}
