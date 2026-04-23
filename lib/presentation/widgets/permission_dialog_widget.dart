import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/dialog_util.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/option_tile_widget.dart';

class PermissionDialog extends StatelessWidget {
  final ImagePermissionHandler provider;
  final int? index;
  final bool showRemoveOption;
  const PermissionDialog({
    super.key,
    required this.provider,
    this.index,
    this.showRemoveOption = false,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dialogWidth = DialogUtil.getDialogWidth(context);
    final spacing = (size.height * 0.02).clamp(12.0, 20.0);

    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Center(
        child: Text(
          "Choose Option",
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OptionTileWidget(
              icon: Icons.camera_alt,
              title: "Camera",
              onTap: () => provider.handleImagePermission(
                context: context,
                isCamera: true,
                index: index,
              ),
            ),
            SizedBox(height: spacing),
            OptionTileWidget(
              icon: Icons.photo_library,
              title: "Library",
              onTap: () => provider.handleImagePermission(
                context: context,
                isCamera: false,
                index: index,
              ),
            ),
            if (showRemoveOption) ...[
              SizedBox(height: spacing),
              OptionTileWidget(
                icon: Icons.delete_outline,
                title: "Remove Photo",
                color: ColourStyles.colorRed,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => ActionConfirmationWidget(
                      title: "Confirm Removal",
                      actionText: "Remove",
                      displayName: "profile photo",
                      actionColor: ColourStyles.colorRed,
                      onConfirm: () async {
                        provider.removeImage(index: index);
                        return true;
                      },
                    ),
                  );
                },
              ),
            ],
            SizedBox(height: spacing * 1.5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyles.dialogBackButton(context),
                onPressed: () => Navigator.pop(context),
                child: Text("Back", style: TextStyles.buttonTextBlack(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
