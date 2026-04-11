import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/dialog_util.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';

// Dialog widget used to add or edit profile details
class EditDetailsWidget extends StatefulWidget {
  final String title;
  final String? initialValue;
  final String fieldType;
  final int? maxLength;
  final bool isEditing;
  final Future<void> Function(String value) onSave;
  final String? Function(String value)? duplicateValidator;

  const EditDetailsWidget({
    super.key,
    required this.title,
    this.initialValue,
    required this.fieldType,
    this.maxLength,
    required this.onSave,
    this.isEditing = false,
    this.duplicateValidator,
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
    final dialogWidth = DialogUtil.getDialogWidth(context);
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      // Dialog title
      titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
      title: Center(
        child: Text(
          "${widget.isEditing ? 'Edit' : 'Add'} ${widget.title}",
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      // Input field
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: widget.maxLength,
            textAlign: TextAlign.center,
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
            validator: (value) {
              // Basic formatting string validation
              final error = SelectValidatorUtil.validate(value, widget.fieldType);
              if (error != null) return error;
              // Custom duplicate check logic
              if (widget.duplicateValidator != null && value != null) {
                return widget.duplicateValidator!(value);
              }
              return null;
            },
          ),
        ),
      ),
      // Action buttons
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  
                  bool wasConfirmed = false;
                  
                  if (widget.isEditing) {
                    // Show confirmation dialog ONLY when editing
                    await showDialog(
                      context: context,
                      builder: (_) => ActionConfirmationWidget(
                        title: "Confirm Update",
                        actionText: "Update",
                        displayName: widget.title,
                        actionColor: ColourStyles.colorGreen,
                        showSnackbar: false, // Handled manually below
                        onConfirm: () async {
                          await widget.onSave(controller.text.trim());
                          wasConfirmed = true;
                          return true;
                        },
                      ),
                    );
                  } else {
                    // Addition: save immediately without confirmation
                    await widget.onSave(controller.text.trim());
                    wasConfirmed = true;
                  }

                  // If user closed dialog or pressed cancel (for editing), stop here
                  if (!wasConfirmed) return;
                  if (!context.mounted) return;
                  final message = widget.isEditing
                      ? "${widget.title} updated successfully"
                      : "${widget.title} added successfully";
                  SnackbarUtil.showSnackBar(context, message, false);
                  Navigator.pop(context); // Close the edit dialog
                },
                // Button label
                child: Text(
                  widget.isEditing ? "Update" : "Add",
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
