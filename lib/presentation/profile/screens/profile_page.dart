import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/profile/widgets/profile_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final sectionSpacing = (size.height * 0.04).clamp(20.0, 40.0);
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Profile",
        centeredTitle: false,
        showAvatar: false,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Consumer<ProfilePageProvider>(
          builder: (context, provider, _) {
            final user = provider.user;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: UserAvatarEditWidget(
                        imagePath: user?.profileImage,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => PermissionDialog(
                              provider: context.read<ProfilePageProvider>(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: sectionSpacing),
                    Text(
                      "Personal Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    const SizedBox(height: 12),
                    ProfileDetailsWidget(
                      items: provider.personalInfo,
                      onSave: (fieldType, value) async {
                        switch (fieldType) {
                          case 'name':
                            user?.fullName = value;
                            break;
                          case 'email':
                            user?.gmail = value;
                            break;
                          case 'personal number':
                            user?.personalNumber = value;
                            break;
                        }
                        await provider.updateUser();
                      },
                    ),
                    SizedBox(height: sectionSpacing),
                    Text(
                      "Shop Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    const SizedBox(height: 12),
                    ProfileDetailsWidget(
                      items: provider.shopInfo,
                      onSave: (fieldType, value) async {
                        switch (fieldType) {
                          case 'shop name':
                            user?.shopName = value;
                            break;
                          case 'address':
                            user?.shopAdress = value;
                            break;
                          case 'shop number':
                            user?.shopNumber = value;
                            break;
                        }
                        await provider.updateUser();
                      },
                    ),
                    SizedBox(height: sectionSpacing),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
