import 'package:stock_pilot/core/utils/form_validator_util.dart';

// Utility class used to select the correct validator
class SelectValidatorUtil {
  static String? validate(String? value, String type) {
    // Convert type to lowercase to make matching case-insensitive
    switch (type.toLowerCase()) {
      // User name validation
      case 'name':
        return FormValidatorUtil.validateName(value, "Full Name");
      // Personal phone number validation
      case 'personal number':
        return FormValidatorUtil.validatePhone(value, "Phone Number");
      // Email validation
      case 'email':
        return FormValidatorUtil.validateEmail(value, "Email");
      // Shop name validation
      case 'shop name':
        return FormValidatorUtil.validateName(value, "Shop Name");
      // Address validation
      case 'address':
        return FormValidatorUtil.validateAddress(value, "Address");
      // Shop phone number validation
      case 'shop number':
        return FormValidatorUtil.validatePhone(value, "Phone Number");
      // Product name validation
      case 'product name':
        return FormValidatorUtil.validateProductName(value, "Product Name");
      // Product description validation
      case 'product description':
        return FormValidatorUtil.validateProductDescription(
          value,
          "Product description",
        );
      // Product brand validation
      case 'product brand':
        return FormValidatorUtil.validateProductfilter(value, "Product brand");
      // Product category validation
      case 'product category':
        return FormValidatorUtil.validateProductfilter(
          value,
          "Product category",
        );
      // Purchase rate validation
      case 'purchase rate':
        return FormValidatorUtil.validateRate(value, "Purchase rate");
      // Sales rate validation
      case 'sales rate':
        return FormValidatorUtil.validateRate(value, "Sales rate");
      // Item stock count validation
      case 'item count':
        return FormValidatorUtil.validateCount(value, "Item count");
      // Low stock threshold validation
      case 'low stock count':
        return FormValidatorUtil.validateCount(value, "Low stock count");
      // Category filter validation
      case 'category':
        return FormValidatorUtil.validatefilter(value, "Category");
      // Brand filter validation
      case 'brand':
        return FormValidatorUtil.validatefilter(value, "Brand");
      // Default case when no validator matches
      default:
        return null;
    }
  }
}
