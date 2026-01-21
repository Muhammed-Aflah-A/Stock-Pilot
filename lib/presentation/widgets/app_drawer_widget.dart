import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.sizeOf(context).height;
    return Drawer(
      backgroundColor: ColourStyles.primaryColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: ColourStyles.primaryColor),
            accountName: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return Text(
                  "${provider.user?.fullName}",
                  style: TextStyles.primaryText(context),
                );
              },
            ),
            accountEmail: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return Text(
                  "${provider.user?.gmail}",
                  style: TextStyles.primaryText(context),
                );
              },
            ),
            currentAccountPicture: const UserAvatarWidget(),
          ),
          Expanded(
            child: Consumer<DrawerProvider>(
              builder: (context, provider, child) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: currentHeight * 0.01),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: currentHeight * 0.005),
                  itemCount: provider.drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.drawerItems[index];
                    return ListTile(
                      selected: provider.selectedIndex == index,
                      selectedTileColor: ColourStyles.selectionColor,
                      tileColor: ColourStyles.primaryColor,
                      leading: Image.asset(
                        item.icon!,
                        height: _scale(context, 28),
                        width: _scale(context, 28),
                      ),
                      title: Text(
                        item.title!,
                        style: TextStyles.titleText(
                          context,
                        ),
                      ),
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
