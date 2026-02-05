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
  late TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      title: Center(
        child: Text(
          "${widget.isEditing ? 'Edit' : 'Add'} ${widget.title}",
          style: TextStyles.dialogueHeading(context),
        ),
      ),
      content: SizedBox(
        width: widget.screenWidth * 0.8,
        child: Form(
          key: formKey,
          child: TextFormField(
            maxLength: widget.maxlength,
            controller: controller,
            keyboardType: KeyboardTypeUtil.getKeyboardType(widget.fieldtype),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) =>
                SelectValidatorUtil.validate(value, widget.fieldtype),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyles.smallDialogBackButton(context),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "cancel",
                    style: TextStyles.smallButtonTextBlack(context),
                  ),
                ),
              ),
              SizedBox(width: widget.screenWidth * 0.03),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyles.smallDialogNextButton(context),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await widget.onSave(controller.text.trim());
                      if (context.mounted) {
                        final message = widget.isEditing
                            ? "${widget.title} updated successfully"
                            : "${widget.title} added successfully";
                        SnackbarUtil.showSnackBar(context, message, false);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    "save",
                    style: TextStyles.smallButtonTextWhite(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
