import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/option_tile_widget.dart';

/// Dialog that lets the user choose where to pick the image from
class PermissionDialog extends StatelessWidget {
  // Provider that handles permission + image picking logic
  final ImagePermissionHandler provider;
  // Optional index (used when selecting image for a specific item)
  final int? index;
  // Optional flag to show remove photo option
  final bool showRemoveOption;
  const PermissionDialog({
    super.key,
    required this.provider,
    this.index,
    this.showRemoveOption = false,
  });
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.sizeOf(context);
    // Dialog width = 85% of screen width
    // clamp keeps it between 280 and 420 for better layout
    final dialogWidth = (size.width * 0.85).clamp(280.0, 420.0);
    // Spacing between widgets depending on screen height
    final spacing = (size.height * 0.02).clamp(12.0, 20.0);

    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Dialog title
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
            /// Camera option
            OptionTileWidget(
              icon: Icons.camera_alt,
              title: "Camera",
              // Ask provider to handle camera permission + image pick
              onTap: () => provider.handleImagePermission(
                context: context,
                isCamera: true,
                index: index,
              ),
            ),
            // Space between options
            SizedBox(height: spacing),
            /// Gallery option
            OptionTileWidget(
              icon: Icons.photo_library,
              title: "Library",
              // Ask provider to open gallery
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
            // Back button to close the dialog
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyles.dialogBackButton(context),
                // Close dialog
                onPressed: () => Navigator.pop(context),
                // Button label
                child: Text("Back", style: TextStyles.buttonTextBlack(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
