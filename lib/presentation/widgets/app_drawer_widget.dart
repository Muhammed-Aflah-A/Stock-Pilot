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
    final size = MediaQuery.of(context).size;
    final verticalPadding = (size.height * 0.01).clamp(8.0, 16.0);
    final itemSpacing = (size.height * 0.005).clamp(4.0, 10.0);

    return Drawer(
      backgroundColor: ColourStyles.primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            Consumer<ProfilePageProvider>(
              builder: (context, profileProvider, _) {
                final user = profileProvider.user;
                return UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: ColourStyles.primaryColor,
                  ),
                  accountName: Text(
                    user?.fullName ?? "User",
                    style: TextStyles.primaryText(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  accountEmail: Text(
                    user?.gmail ?? "",
                    style: TextStyles.primaryText(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  currentAccountPicture: const UserAvatarWidget(),
                );
              },
            ),
            Expanded(
              child: Consumer<DrawerProvider>(
                builder: (context, drawerProvider, _) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    itemCount: drawerProvider.drawerItems.length,
                    separatorBuilder: (_, __) => SizedBox(height: itemSpacing),
                    itemBuilder: (context, index) {
                      final item = drawerProvider.drawerItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.06,
                        ),
                        selected: drawerProvider.selectedIndex == index,
                        selectedTileColor: ColourStyles.selectionColor,
                        tileColor: ColourStyles.primaryColor,
                        leading: item.icon,
                        title: Text(
                          item.title!,
                          style: TextStyles.titleText(context),
                        ),
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
          ],
        ),
      ),
    );
  }
}
