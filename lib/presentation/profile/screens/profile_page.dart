import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: UserAvatarEditWidget()),
              SizedBox(height: h * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),
                  EditWidget(
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
                  SizedBox(height: h * 0.01),
                  Text("Shop Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),
                  EditWidget(
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
