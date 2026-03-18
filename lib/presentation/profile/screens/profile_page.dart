import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/profile/widgets/profile_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive spacing
    final size = MediaQuery.of(context).size;
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final sectionSpacing = (size.height * 0.04).clamp(20.0, 40.0);
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // AppBar widget
      appBar: AppBarWidget(
        showLeading: false,
        title: "Profile",
        centeredTitle: false,
        showAvatar: false,
      ),
      // Drawer widget
      drawer: AppDrawer(),
      body: SafeArea(
        child: Consumer<ProfilePageProvider>(
          builder: (context, provider, _) {
            // Current user from provider
            final user = provider.user;
            return SingleChildScrollView(
              // Closes keyboard when user scrolls
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile avatar with edit option
                    Center(
                      child: UserAvatarEditWidget(
                        imagePath: user?.profileImage,
                        // Opens camera/gallery permission dialog
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
                    // Section title
                    Text(
                      "Personal Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    SizedBox(height: 12),
                    // Personal profile fields
                    ProfileDetailsWidget(items: provider.personalInfo),
                    SizedBox(height: sectionSpacing),
                    // Shop section title
                    Text(
                      "Shop Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    SizedBox(height: 12),
                    // Shop information fields
                    ProfileDetailsWidget(items: provider.shopInfo),
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
