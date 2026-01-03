import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';

class UserAvatarEditWidget extends StatelessWidget {
  const UserAvatarEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<ProfileCreationProvider>(
          builder: (context, provider, child) {
            return CircleAvatar(
              radius: 50,
              backgroundColor: ColourStyles.primaryColor_2,
              backgroundImage:
                  (provider.profileImage != null &&
                      File(provider.profileImage!).existsSync())
                  ? FileImage(File(provider.profileImage!))
                  : AssetImage(AppImages.profilePicture),
            );
          },
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PermissionDialog();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
