import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

// Dialog widget used to add or edit profile details
class EditDetailsWidget extends StatefulWidget {
  final String title;
  final String? initialValue;
  final String fieldType;
  final int? maxLength;
  final bool isEditing;
  final Future<void> Function(String value) onSave;

  const EditDetailsWidget({
    super.key,
    required this.title,
    this.initialValue,
    required this.fieldType,
    this.maxLength,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  State<EditDetailsWidget> createState() => _EditDetailsWidgetState();
}

class _EditDetailsWidgetState extends State<EditDetailsWidget> {
  late final TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize text field with existing value
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    // Dispose controller to prevent memory leaks
    controller.dispose();
    super.dispose();
  }

  // Reusable border style for text field
  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width directly from context
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = (screenWidth * 0.85).clamp(280.0, 500.0);
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      // Dialog title
      title: Center(
        child: Text(
          "${widget.isEditing ? 'Edit' : 'Add'} ${widget.title}",
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      // Input field
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: widget.maxLength,
            // Keyboard type based on field
            keyboardType: KeyboardTypeUtil.getKeyboardType(widget.fieldType),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: _border(ColourStyles.primaryColor_2),
              focusedBorder: _border(ColourStyles.primaryColor_2),
              errorBorder: _border(ColourStyles.colorRed),
              focusedErrorBorder: _border(ColourStyles.colorRed),
            ),
            // Field validation
            validator: (value) =>
                SelectValidatorUtil.validate(value, widget.fieldType),
          ),
        ),
      ),
      // Action buttons
      actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        Row(
          children: [
            // Cancel button
            Expanded(
              child: ElevatedButton(
                style: ButtonStyles.smallDialogBackButton(context),
                onPressed: () => Navigator.pop(context),
                // Button label
                child: Text(
                  "Cancel",
                  style: TextStyles.smallButtonTextBlack(context),
                ),
              ),
            ),
            SizedBox(width: dialogWidth * 0.05),
            // Save button
            Expanded(
              child: ElevatedButton(
                style: ButtonStyles.smallDialogNextButton(context),
                onPressed: () async {
                  // Validate form
                  if (!formKey.currentState!.validate()) return;
                  // Call save function
                  await widget.onSave(controller.text.trim());
                  if (!context.mounted) return;
                  final message = widget.isEditing
                      ? "${widget.title} updated successfully"
                      : "${widget.title} added successfully";
                  SnackbarUtil.showSnackBar(context, message, false);
                  Navigator.pop(context);
                },
                // Button label
                child: Text(
                  "Save",
                  style: TextStyles.smallButtonTextWhite(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
