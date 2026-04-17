import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/dialog_util.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';

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
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
      titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
      title: Center(
        child: Text(
          "${widget.isEditing ? 'Edit' : 'Add'} ${widget.title}",
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: widget.maxLength,
            textAlign: TextAlign.center,
            keyboardType: KeyboardTypeUtil.getKeyboardType(widget.fieldType),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: _border(ColourStyles.primaryColor_2),
              focusedBorder: _border(ColourStyles.primaryColor_2),
              errorBorder: _border(ColourStyles.colorRed),
              focusedErrorBorder: _border(ColourStyles.colorRed),
            ),
            validator: (value) {
              final error = SelectValidatorUtil.validate(value, widget.fieldType);
              if (error != null) return error;
              if (widget.duplicateValidator != null && value != null) {
                return widget.duplicateValidator!(value);
              }
              return null;
            },
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyles.smallDialogBackButton(context),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyles.smallButtonTextBlack(context),
                ),
              ),
            ),
            SizedBox(width: dialogWidth * 0.05),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyles.smallDialogNextButton(context),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  
                  bool wasConfirmed = false;
                  
                  if (widget.isEditing) {
                    await showDialog(
                      context: context,
                      builder: (_) => ActionConfirmationWidget(
                        title: "Confirm Update",
                        actionText: "Update",
                        displayName: widget.title,
                        actionColor: ColourStyles.colorGreen,
                        showSnackbar: false,
                        onConfirm: () async {
                          await widget.onSave(controller.text.trim());
                          wasConfirmed = true;
                          return true;
                        },
                      ),
                    );
                  } else {
                    await widget.onSave(controller.text.trim());
                    wasConfirmed = true;
                  }

                  if (!wasConfirmed) return;
                  if (!context.mounted) return;
                  final message = widget.isEditing
                      ? "${widget.title} updated successfully"
                      : "${widget.title} added successfully";
                  SnackbarUtil.showSnackBar(context, message, false);
                  Navigator.pop(context);
                },
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

