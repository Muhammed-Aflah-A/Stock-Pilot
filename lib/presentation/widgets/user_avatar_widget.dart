import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, child) {
        return CircleAvatar(
          radius: currentHeigth*0.03,
          backgroundColor: ColourStyles.primaryColor_2,
          backgroundImage:
              (provider.user?.profileImage != null &&
                  File(provider.user!.profileImage!).existsSync())
              ? FileImage(File(provider.user!.profileImage!))
              : AssetImage(AppImages.profilePicture),
        );
      },
    );
  }
}
