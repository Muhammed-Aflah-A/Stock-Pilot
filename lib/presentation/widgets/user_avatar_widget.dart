import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
// Widget used to show profile photo in appbar
class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, child) {
        // Profile image
        return CircleAvatar(
          radius: 23,
          backgroundColor: ColourStyles.primaryColor_2,
          // gets image from util (file / network / asset)
          backgroundImage: ImageUtil.getProfileImage(
            provider.user?.profileImage,
          ),
        );
      },
    );
  }
}
