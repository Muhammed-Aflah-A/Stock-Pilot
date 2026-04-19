import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/data/models/drawer_model.dart';

class DrawerProvider with ChangeNotifier {
  final List<DrawerItems> drawerItems = [
    DrawerItems(
      icon: Icons.person,
      title: 'Profile',
      navigation: AppRoutes.profilePage,
    ),
    DrawerItems(
      icon: Icons.space_dashboard,
      title: 'Dashboard',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: Icons.inventory_2,
      title: 'Products',
      navigation: AppRoutes.productListPage,
    ),
    DrawerItems(
      icon: Icons.category,
      title: 'Category',
      navigation: AppRoutes.category,
    ),
    DrawerItems(icon: Icons.sell, title: 'Brand', navigation: AppRoutes.brand),
    DrawerItems(
      icon: Icons.warning_amber,
      title: 'Low stock',
      navigation: AppRoutes.lowStockPage,
    ),
    DrawerItems(
      icon: Icons.cancel,
      title: 'Out of stock',
      navigation: AppRoutes.outOfStockPage,
    ),
    DrawerItems(
      icon: Icons.shopping_cart,
      title: 'Cart',
      navigation: AppRoutes.cartListPage,
    ),
    DrawerItems(
      icon: Icons.history,
      title: 'History',
      navigation: AppRoutes.historyListPage,
    ),
    DrawerItems(
      icon: Icons.trending_up,
      title: 'Revenue',
      navigation: AppRoutes.revenuePage,
    ),
    DrawerItems(
      icon: Icons.settings,
      title: 'Settings',
      navigation: AppRoutes.dashboard,
    ),
  ];
  int selectedIndex = 0;
  void selectedDrawerItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

