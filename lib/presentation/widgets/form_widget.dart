import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class FormWidget extends StatelessWidget {
  final int? maxline;
  final int? maxlength;
  final FocusNode? focus;
  final TextInputType keyboard;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextInputAction action;
  final void Function(String?) onFieldSubmitted;

  const FormWidget({
    this.maxline,
    this.maxlength,
    super.key,
    this.focus,
    required this.keyboard,
    this.labelText,
    this.hintText,
    this.initialValue,
    required this.validator,
    required this.onSaved,
    required this.action,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxline,
      maxLength: maxlength,
      focusNode: focus,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.formLabel,
        hintText: hintText,
        hintStyle: TextStyles.formHint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColourStyles.colorRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColourStyles.colorRed, width: 2),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      textInputAction: action,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
