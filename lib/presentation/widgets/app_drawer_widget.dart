import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
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
            currentAccountPicture: UserAvatarWidget(),
          ),
          Expanded(
            child: Consumer<DrawerProvider>(
              builder: (context, provider, child) {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: currentHeigth * 0.01),
                  itemCount: provider.drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.drawerItems[index];
                    return ListTile(
                      selected: provider.selectedIndex == index,
                      selectedTileColor: ColourStyles.baseBackgroundColor,
                      tileColor: ColourStyles.primaryColor,
                      leading: Image.asset(
                        item.icon!,
                        height: currentHeigth * 0.045,
                        width: currentHeigth * 0.045,
                      ),
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
