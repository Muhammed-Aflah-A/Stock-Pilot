// import 'package:flutter/material.dart';
// import 'package:stock_pilot/core/theme/button_styles.dart';
// import 'package:stock_pilot/core/theme/colours_styles.dart';
// import 'package:stock_pilot/core/theme/text_styles.dart';
// import 'package:stock_pilot/core/utils/permission_util.dart';
// import 'package:stock_pilot/presentation/widgets/option_tile_widget.dart';

// class PermissionDialog extends StatelessWidget {
//   final dynamic provider;
//   final int? index;
//   const PermissionDialog({super.key, required this.provider, this.index});

//   double _scale(BuildContext context, double size) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     if (screenWidth < 360) return size * 0.9;
//     if (screenWidth < 600) return size * 1.0;
//     if (screenWidth < 900) return size * 1.1;
//     return size * 1.2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: ColourStyles.primaryColor,
//       title: Center(
//         child: Text(
//           "Choose option",
//           style: TextStyles.dialogueHeading(context),
//         ),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           OptionTileWidget(
//             icon: Icons.camera_alt,
//             title: "Camera",
//             onTap: () => PermissionUtil.handleImagePermission(
//               context: context,
//               provider: provider,
//               isCamera: true,
//               index: index,
//             ),
//           ),
//           OptionTileWidget(
//             icon: Icons.photo_library,
//             title: "Library",
//             onTap: () => PermissionUtil.handleImagePermission(
//               context: context,
//               provider: provider,
//               isCamera: false,
//               index: index,
//             ),
//           ),
//           SizedBox(height: _scale(context, 20)),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ButtonStyles.dialogBackButton(context),
//             child: Text("Back", style: TextStyles.buttonTextBlack(context)),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/presentation/widgets/option_tile_widget.dart';

class PermissionDialog<T> extends StatelessWidget {
  final T provider;
  final int? index;

  const PermissionDialog({super.key, required this.provider, this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = (size.width * 0.85).clamp(280.0, 420.0);
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
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: spacing),
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
              SizedBox(height: spacing * 1.5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyles.dialogBackButton(context),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Back",
                    style: TextStyles.buttonTextBlack(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
