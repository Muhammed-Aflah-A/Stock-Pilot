import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

class EditDetailsWidget extends StatefulWidget {
  final String title;
  final String? initialValue;
  final dynamic fieldtype;
  final int? maxlength;
  final double screenWidth;
  final bool isEditing;
  final Future<void> Function(String value) onSave;

  const EditDetailsWidget({
    super.key,
    required this.title,
    this.initialValue,
    this.fieldtype,
    this.maxlength,
    required this.screenWidth,
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
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = ColourStyles.colorRed;
    final dialogWidth = (widget.screenWidth * 0.85).clamp(280.0, 500.0);
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      title: Center(
        child: Text(
          "${widget.isEditing ? 'Edit' : 'Add'} ${widget.title}",
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLength: widget.maxlength,
            keyboardType: KeyboardTypeUtil.getKeyboardType(widget.fieldtype),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: _border(ColourStyles.primaryColor_2),
              focusedBorder: _border(ColourStyles.primaryColor_2),
              errorBorder: _border(errorColor),
              focusedErrorBorder: _border(errorColor),
            ),
            validator: (value) =>
                SelectValidatorUtil.validate(value, widget.fieldtype),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  await widget.onSave(controller.text.trim());
                  if (!context.mounted) return;
                  final message = widget.isEditing
                      ? "${widget.title} updated successfully"
                      : "${widget.title} added successfully";
                  SnackbarUtil.showSnackBar(context, message, false);
                  Navigator.pop(context);
                },
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
