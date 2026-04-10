import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    // Dismiss keyboard when drawer starts opening
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColourStyles.primaryColor,
      child: Column(
        children: [
          // Profile section
          Consumer<ProfilePageProvider>(
            builder: (context, profileProvider, _) {
              final user = profileProvider.user;
              return UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: ColourStyles.primaryColor),
                // Account name
                accountName: Text(
                  user?.fullName ?? "User",
                  style: TextStyles.primaryText(context),
                  overflow: TextOverflow.ellipsis,
                ),
                // Account email
                accountEmail: Text(
                  user?.gmail ?? "user@gmail.com",
                  style: TextStyles.primaryText(context),
                  overflow: TextOverflow.ellipsis,
                ),
                // Profile photo
                currentAccountPicture: const UserAvatarWidget(),
              );
            },
          ),
          // Drawer items
          Expanded(
            child: SafeArea(
              top: false,
              child: Consumer<DrawerProvider>(
                builder: (context, drawerProvider, _) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    itemCount: drawerProvider.drawerItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final item = drawerProvider.drawerItems[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        selected: drawerProvider.selectedIndex == index,
                        selectedTileColor: ColourStyles.selectionColor,
                        tileColor: ColourStyles.primaryColor,
                        // Drawer item icon
                        leading: Icon(
                          item.icon,
                          color: ColourStyles.primaryColor_2,
                        ),
                        // Drawer item title
                        title: Text(
                          item.title!,
                          style: TextStyles.titleText(context),
                        ),
                        // Drawer item tap
                        onTap: () {
                          drawerProvider.selectedDrawerItem(index);
                          Navigator.pop(context);
                          if (ModalRoute.of(context)?.settings.name !=
                              item.navigation) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "${item.navigation}",
                              (route) => false,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
