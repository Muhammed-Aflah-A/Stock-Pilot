import 'package:stock_pilot/core/utils/form_validator_util.dart';

class SelectValidatorUtil {
  static String? validate(String? value, String type) {
    switch (type.toLowerCase()) {
      case 'name':
        return FormValidatorUtil.validateName(value, "Full Name");
      case 'personal number':
        return FormValidatorUtil.validatePhone(value, "Phone Number");
      case 'email':
        return FormValidatorUtil.validateEmail(value, "Email");
      case 'shop name':
       return FormValidatorUtil.validateName(value, "Shop Name");
      case 'address':
        return FormValidatorUtil.validateAddress(value, "Address");
        case 'shop number':
        return FormValidatorUtil.validatePhone(value, "Phone Number");
      default:
        return null;
    }
  }
}
