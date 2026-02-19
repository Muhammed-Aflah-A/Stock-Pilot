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
  final void Function(String?)? onFieldSubmitted;
  final bool obscure;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;

  const FormWidget({
    super.key,
    this.maxline = 1,
    this.maxlength,
    this.focus,
    required this.keyboard,
    this.labelText,
    this.hintText,
    this.initialValue,
    required this.validator,
    required this.onSaved,
    required this.action,
    this.onFieldSubmitted,
    this.obscure = false,
    this.filled = false,
    this.contentPadding,
  });

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        contentPadding ??
        EdgeInsets.symmetric(horizontal: 14, vertical: maxline == 1 ? 14 : 16);

    return TextFormField(
      initialValue: initialValue,
      maxLines: obscure ? 1 : maxline,
      maxLength: maxlength,
      focusNode: focus,
      keyboardType: keyboard,
      obscureText: obscure,
      style: TextStyles.formLabel(context),
      textInputAction: action,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.formLabel(context),
        hintText: hintText,
        hintStyle: TextStyles.formHint(context),
        counterText: "",
        filled: filled,
        fillColor: filled ? ColourStyles.primaryColor : null,
        contentPadding: padding,

        enabledBorder: _border(ColourStyles.primaryColor_2),
        focusedBorder: _border(ColourStyles.primaryColor_2),
        errorBorder: _border(ColourStyles.colorRed),
        focusedErrorBorder: _border(ColourStyles.colorRed),
      ),
    );
  }
}
