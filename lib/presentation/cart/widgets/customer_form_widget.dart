import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class CustomerFormWidget extends StatelessWidget {
  final Icon? prefixIcon;
  final int? maxlines;
  final int? maxlength;
  final FocusNode? focus;
  final TextInputType keyboard;
  final String? labelText;
  final String? hintText;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextInputAction action;
  final void Function(String?)? onFieldSubmitted;

  const CustomerFormWidget({
    super.key,
    this.prefixIcon,
    this.maxlines = 1,
    this.maxlength,
    this.focus,
    required this.keyboard,
    this.labelText,
    this.hintText,
    required this.validator,
    required this.onSaved,
    required this.action,
    this.onFieldSubmitted,
  });

  static UnderlineInputBorder _border(Color color) {
    return UnderlineInputBorder(borderSide: BorderSide(color: color, width: 1));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      maxLength: maxlength,
      focusNode: focus,
      keyboardType: keyboard,
      style: TextStyles.customerFormLabel(context),
      textInputAction: action,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyles.customerFormLabel(context),
        hintText: hintText,
        hintStyle: TextStyles.customerFormLabel(context),
        counterText: '',
        enabledBorder: _border(ColourStyles.primaryColor_2),
        focusedBorder: _border(ColourStyles.primaryColor_2),
        errorBorder: _border(ColourStyles.colorRed),
        focusedErrorBorder: _border(ColourStyles.colorRed),
      ),
    );
  }
}

