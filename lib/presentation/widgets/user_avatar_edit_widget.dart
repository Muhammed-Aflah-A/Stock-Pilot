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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: ColourStyles.primaryColor_2,
          backgroundImage: (imagePath != null && File(imagePath!).existsSync())
              ? FileImage(File(imagePath!))
              : AssetImage(AppImages.profilePicture),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColourStyles.primaryColor_2,
              shape: BoxShape.circle,
              border: Border.all(color: ColourStyles.primaryColor, width: 3),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.edit,
                size: 18,
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
