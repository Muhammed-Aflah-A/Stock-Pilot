import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';

// Widget that shows the user's profile image with an edit button
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
      // Allows the edit button to slightly overflow the avatar
      clipBehavior: Clip.none,
      children: [
        // Profile image
        CircleAvatar(
          radius: 50,
          backgroundColor: ColourStyles.primaryColor_2,
          // Loads image using utility function
          backgroundImage: ImageUtil.getProfileImage(imagePath),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: InkWell(
            onTap: onPressed,
            customBorder: CircleBorder(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ColourStyles.primaryColor_2,
                shape: BoxShape.circle,
                border: Border.all(color: ColourStyles.primaryColor, width: 3),
              ),
              child: Icon(
                Icons.edit,
                size: 18,
                color: ColourStyles.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
