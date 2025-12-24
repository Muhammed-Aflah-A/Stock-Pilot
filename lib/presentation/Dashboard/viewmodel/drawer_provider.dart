import 'package:flutter/widgets.dart';
import 'package:stock_pilot/core/assets/app_icons.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/data/models/drawer_model.dart';

class DrawerProvider with ChangeNotifier {
  final List<DrawerItems> drawerItems = [
    DrawerItems(
      icon: AppIcons.userAvatar,
      title: 'Profile',
      navigation: AppRoutes.profilePage,
    ),
    DrawerItems(
      icon: AppIcons.dashboard,
      title: 'Dashboard',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.product,
      title: 'Products',
      navigation: AppRoutes.productListPage,
    ),
    DrawerItems(
      icon: AppIcons.category,
      title: 'Category',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.brand,
      title: 'Brand',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.lowStock,
      title: 'Low stock',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.outOfStock,
      title: 'Out of stock',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.history,
      title: 'History',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: AppIcons.revenue,
      title: 'Revenue',
      navigation: AppRoutes.dashboard,
    ),
  ];
  int selectedIndex = 0;
  void selectedDrawerItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
