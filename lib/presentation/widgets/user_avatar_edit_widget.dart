import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';

class UserAvatarEditWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPressed;

  const UserAvatarEditWidget({
    super.key,
    required this.onPressed,
    required this.imagePath,
  });

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = _scale(context, 50);
    final double editButtonSize = _scale(context, 36);
    final double iconSize = _scale(context, 18);

    return Stack(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: ColourStyles.primaryColor_2,
          backgroundImage: ImageUtil.getProfileImage(imagePath),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: editButtonSize,
              height: editButtonSize,
              decoration: BoxDecoration(
                color: ColourStyles.primaryColor_2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColourStyles.primaryColor,
                  width: _scale(context, 3),
                ),
              ),
              child: Icon(
                Icons.edit,
                size: iconSize,
                color: ColourStyles.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
