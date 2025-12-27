import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    // Screen height and width for responsive sizing
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: ColourStyles.primaryColor,
        toolbarHeight: 100,

        // App bar title
        title: Text("Products", style: TextStyles.heading_2),

        // Profile image shown on the right side
        actions: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: ColourStyles.primaryColor_2,

                  // Show user profile image if exists, else default image
                  backgroundImage:
                      (provider.user?.profileImage != null &&
                          File(provider.user!.profileImage!).existsSync())
                      ? FileImage(File(provider.user!.profileImage!))
                      : AssetImage(AppImages.profilePicture),
                );
              },
            ),
          ),
        ],
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        backgroundColor: ColourStyles.primaryColor,
        child: Column(
          children: [
            // Drawer header showing user info
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: ColourStyles.primaryColor),

              // User full name
              accountName: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.fullName}",
                    style: TextStyles.primaryText,
                  );
                },
              ),

              // User email
              accountEmail: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.gmail}",
                    style: TextStyles.primaryText,
                  );
                },
              ),

              // User profile image
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

            // Drawer menu items
            Expanded(
              child: Consumer<DrawerProvider>(
                builder: (context, provider, child) {
                  return ListView.separated(
                    // Space between drawer items
                    separatorBuilder: (context, index) =>
                        SizedBox(height: h * 0.01),

                    itemCount: provider.drawerItems.length,

                    itemBuilder: (context, index) {
                      final item = provider.drawerItems[index];

                      return ListTile(
                        // Highlight selected drawer item
                        selected: provider.selectedIndex == index,
                        selectedTileColor: ColourStyles.baseBackgroundColor,
                        tileColor: ColourStyles.primaryColor,

                        // Drawer icon
                        leading: Image.asset(item.icon!, height: 35, width: 35),

                        // Drawer title
                        title: Text(
                          item.title!,
                          style: TextStyles.primaryText_2,
                        ),

                        // Handle drawer item tap
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
      ),
    );
  }
}
