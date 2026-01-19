import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class UserAvatarEditWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPressed;

  const UserAvatarEditWidget({
    super.key,
    required this.onPressed,
    required this.imagePath,
  });

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
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
          backgroundImage: (imagePath != null && File(imagePath!).existsSync())
              ? FileImage(File(imagePath!))
              : AssetImage(AppImages.profilePicture) as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
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
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.edit,
                size: iconSize,
                color: ColourStyles.primaryColor,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
