import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final double responsiveRadius = _scale(context, 25);
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, child) {
        return CircleAvatar(
          radius: responsiveRadius,
          backgroundColor: ColourStyles.primaryColor_2,
          backgroundImage: ImageUtil.getProfileImage(
            provider.user?.profileImage,
          ),
        );
      },
    );
  }
}
