import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/presentation/widgets/option_tile_widget.dart';

class PermissionDialog extends StatelessWidget {
  final dynamic provider;
  final int? index;
  const PermissionDialog({super.key, required this.provider, this.index});

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      title: Center(
        child: Text(
          "Choose option",
          style: TextStyles.dialogueHeading(context),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OptionTileWidget(
            icon: Icons.camera_alt,
            title: "Camera",
            onTap: () => PermissionUtil.handleImagePermission(
              context: context,
              provider: provider,
              isCamera: true,
              index: index,
            ),
          ),
          OptionTileWidget(
            icon: Icons.photo_library,
            title: "Library",
            onTap: () => PermissionUtil.handleImagePermission(
              context: context,
              provider: provider,
              isCamera: false,
              index: index,
            ),
          ),
          SizedBox(height: _scale(context, 20)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyles.dialogBackButton(context),
            child: Text("Back", style: TextStyles.buttonTextBlack(context)),
          ),
        ],
      ),
    );
  }
}
