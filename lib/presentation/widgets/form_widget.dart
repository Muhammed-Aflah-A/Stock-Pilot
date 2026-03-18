import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Reusable form input widget used across the app
class FormWidget extends StatelessWidget {
  // Maximum number of lines allowed in the text field
  final int? maxlines;
  // Maximum number of characters allowed
  final int? maxlength;
  // Focus node used to control focus between fields
  final FocusNode? focus;
  // Keyboard type (text, number, email, etc.)
  final TextInputType keyboard;
  // Label shown above the input
  final String? labelText;
  // Hint text shown inside the field
  final String? hintText;
  // Initial value when the form loads
  final String? initialValue;
  // Function used to validate the input
  final String? Function(String?) validator;
  // Function called when form is saved
  final void Function(String?) onSaved;
  // Action button on keyboard (next, done, etc.)
  final TextInputAction action;
  // Function called when user presses the keyboard action button
  final void Function(String?)? onFieldSubmitted;

  const FormWidget({
    super.key,
    this.maxlines = 1,
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
  });
  // Outline border of textform feild
  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      // If field is password, force single line
      maxLines: maxlines,
      maxLength: maxlength,
      focusNode: focus,
      // Controls keyboard type
      keyboardType: keyboard,
      // Text style of the input
      style: TextStyles.formLabel(context),
      // Keyboard action button
      textInputAction: action,
      // Validation logic passed from outside
      validator: validator,
      // Save value when form is saved
      onSaved: onSaved,
      // Called when keyboard action button is pressed
      onFieldSubmitted: onFieldSubmitted,
      // Starts validating after user interacts with field
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.formLabel(context),
        hintText: hintText,
        hintStyle: TextStyles.formHint(context),
        // Hides the character counter
        counterText: '',
        // Borders for different states
        enabledBorder: _border(ColourStyles.primaryColor_2),
        focusedBorder: _border(ColourStyles.primaryColor_2),
        errorBorder: _border(ColourStyles.colorRed),
        focusedErrorBorder: _border(ColourStyles.colorRed),
      ),
    );
  }
}
