import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class CustomerFormWidget extends StatelessWidget {
  final Icon? prefixIcon;
  // Maximum number of lines allowed in the text field
  final int? maxlines;
  // Maximum number of characters allowed
  final int? maxlength;
  // Focus node used to control focus between fields
  final FocusNode? focus;
  // Keyboard type (text, number, email)
  final TextInputType keyboard;
  // Label shown above the input
  final String? labelText;
  // Hint text shown inside the field
  final String? hintText;
  // Function used to validate the input
  final String? Function(String?) validator;
  // Function called when form is saved
  final void Function(String?) onSaved;
  // Action button on keyboard (next, done)
  final TextInputAction action;
  // Function called when user presses the keyboard action button
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

  // Underline border of textform feild
  static UnderlineInputBorder _border(Color color) {
    return UnderlineInputBorder(borderSide: BorderSide(color: color, width: 1));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // If field is password, force single line
      maxLines: maxlines,
      maxLength: maxlength,
      focusNode: focus,
      // Controls keyboard type
      keyboardType: keyboard,
      // Text style of the input
      style: TextStyles.customerFormLabel(context),
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
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyles.customerFormLabel(context),
        hintText: hintText,
        hintStyle: TextStyles.customerFormLabel(context),
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
