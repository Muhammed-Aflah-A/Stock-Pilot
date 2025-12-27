import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showAvatar;
  const AppBarWidget({
    super.key,
    required this.title,
    required this.showAvatar,
  });
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColourStyles.primaryColor,
      toolbarHeight: 100,
      title: Text(title, style: TextStyles.heading_2),
      actions: showAvatar
          ? [
              Padding(
                padding: EdgeInsets.all(20),
                child: Consumer<ProfilePageProvider>(
                  builder: (context, provider, child) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: ColourStyles.primaryColor_2,
                      backgroundImage:
                          (provider.user?.profileImage != null &&
                              File(provider.user!.profileImage!).existsSync())
                          ? FileImage(File(provider.user!.profileImage!))
                          : AssetImage(AppImages.profilePicture),
                    );
                  },
                ),
              ),
            ]
          : null,
    );
  }
}
