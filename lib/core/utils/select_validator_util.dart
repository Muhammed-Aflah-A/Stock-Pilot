import 'package:stock_pilot/core/utils/form_validator_util.dart';

class SelectValidatorUtil {
  static String? validate(String? value, String type) {
    switch (type.toLowerCase()) {
      case 'name':
        return FormValidatorUtil.validateName(value, "Full Name");
      case 'phone number':
        return FormValidatorUtil.validatePhone(value, "Phone Number");
      case 'email':
        return FormValidatorUtil.validateEmail(value, "Email");
      case 'shop name':
        return FormValidatorUtil.validateShopName(value, "Shop Name");
      case 'address':
      case 'shop address':
        return FormValidatorUtil.validateAddress(value, "Address");
      case 'product name':
        return FormValidatorUtil.validateProductName(value, "Product Name");
      case 'product description':
        return FormValidatorUtil.validateProductDescription(
          value,
          "Product description",
        );
      case 'product brand':
        return FormValidatorUtil.validateProductfilter(value, "Product brand");
      case 'product category':
        return FormValidatorUtil.validateProductfilter(
          value,
          "Product category",
        );
      case 'purchase rate':
        return FormValidatorUtil.validateRate(value, "Purchase rate");
      case 'sales rate':
        return FormValidatorUtil.validateRate(value, "Sales rate");
      case 'item count':
        return FormValidatorUtil.validateCount(value, "Item count");
      case 'low stock count':
        return FormValidatorUtil.validateCount(value, "Low stock count");
      case 'category':
        return FormValidatorUtil.validatefilter(value, "Category");
      case 'brand':
        return FormValidatorUtil.validatefilter(value, "Brand");
      case 'date':
        return FormValidatorUtil.validateDate(value, "Date");
      case 'quantity':
        return FormValidatorUtil.validateItemQty(value, "Quantity");
      default:
        return null;
    }
  }
}
