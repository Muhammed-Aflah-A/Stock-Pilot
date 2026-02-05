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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: UserAvatarEditWidget(
                        imagePath: provider.user?.profileImage,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PermissionDialog(
                              provider: context.read<ProfilePageProvider>(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Personal Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ProfileDetailsWidget(
                      items: provider.personalInfo,
                      onSave: (fieldType, value) async {
                        switch (fieldType) {
                          case 'name':
                            provider.user!.fullName = value;
                            break;
                          case 'personal number':
                            provider.user!.personalNumber = value;
                            break;
                          case 'email':
                            provider.user!.gmail = value;
                            break;
                        }
                        await provider.updateUser();
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      "Shop Information",
                      style: TextStyles.sectionHeading(context),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ProfileDetailsWidget(
                      items: provider.shopInfo,
                      onSave: (fieldtype, value) async {
                        switch (fieldtype) {
                          case 'shop name':
                            provider.user!.shopName = value;
                            break;
                          case 'address':
                            provider.user!.shopAdress = value;
                            break;
                          case 'shop number':
                            provider.user!.shopNumber = value;
                            break;
                        }
                        await provider.updateUser();
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),
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
