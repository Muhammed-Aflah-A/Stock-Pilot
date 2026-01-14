import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/profile_details_widget.dart';
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
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProfilePageProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: false,
        title: "Profile",
        centeredTitle: false,
        showAvatar: false,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: currentHeigth * 0.01,
            horizontal: currentWidth * 0.05,
          ),
          child: ListView(
            children: [
              Center(
                child: Consumer<ProfilePageProvider>(
                  builder: (context, provider, child) {
                    return UserAvatarEditWidget(
                      imagePath: provider.user?.profileImage,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PermissionDialog(
                              provider: context.read<ProfilePageProvider>(),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: currentHeigth * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Information", style: TextStyles.heading_3),
                  SizedBox(height: currentHeigth * 0.01),
                  ProfileDetailsWidget(
                    items: provider.personalInfo,
                    onSave: (provider, feildType, value) {
                      switch (feildType) {
                        case 'name':
                          provider.user!.fullName = value;
                          break;
                        case 'personalNumber':
                          provider.user!.personalNumber = value;
                          break;
                        case 'email':
                          provider.user!.gmail = value;
                          break;
                      }
                    },
                  ),
                  SizedBox(height: currentHeigth * 0.02),
                  Text("Shop Information", style: TextStyles.heading_3),
                  SizedBox(height: currentHeigth * 0.01),
                  ProfileDetailsWidget(
                    items: provider.shopInfo,
                    onSave: (provider, feildType, value) {
                      switch (feildType) {
                        case 'shop name':
                          provider.user!.shopName = value;
                          break;
                        case 'address':
                          provider.user!.shopAdress = value;
                          break;
                        case 'shopNumber':
                          provider.user!.shopNumber = value;
                          break;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
