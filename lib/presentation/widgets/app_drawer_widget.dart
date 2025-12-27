import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: ColourStyles.primaryColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: ColourStyles.primaryColor),
            accountName: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return Text(
                  "${provider.user?.fullName}",
                  style: TextStyles.primaryText,
                );
              },
            ),
            accountEmail: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return Text(
                  "${provider.user?.gmail}",
                  style: TextStyles.primaryText,
                );
              },
            ),
            currentAccountPicture: Consumer<ProfilePageProvider>(
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
          Expanded(
            child: Consumer<DrawerProvider>(
              builder: (context, provider, child) {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: h * 0.01),

                  itemCount: provider.drawerItems.length,

                  itemBuilder: (context, index) {
                    final item = provider.drawerItems[index];

                    return ListTile(
                      selected: provider.selectedIndex == index,
                      selectedTileColor: ColourStyles.baseBackgroundColor,
                      tileColor: ColourStyles.primaryColor,
                      leading: Image.asset(item.icon!, height: 35, width: 35),
                      title: Text(item.title!, style: TextStyles.primaryText_2),
                      onTap: () {
                        provider.selectedDrawerItem(index);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "${item.navigation}");
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
