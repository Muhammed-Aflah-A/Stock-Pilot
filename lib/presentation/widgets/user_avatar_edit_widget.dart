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
  double _scale(BuildContext context, double base) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) return base * 0.85;
    if (width < 480) return base * 0.95;
    if (width < 768) return base * 1.0;
    return base * 1.15;
  }

  @override
  Widget build(BuildContext context) {
    final avatarRadius = _scale(context, 52);
    final editButtonSize = _scale(context, 38);
    final iconSize = _scale(context, 18);
    final borderWidth = _scale(context, 3);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: ColourStyles.primaryColor_2,
          backgroundImage: ImageUtil.getProfileImage(imagePath),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Container(
                width: editButtonSize,
                height: editButtonSize,
                decoration: BoxDecoration(
                  color: ColourStyles.primaryColor_2,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColourStyles.primaryColor,
                    width: borderWidth,
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
        ),
      ],
    );
  }
}
