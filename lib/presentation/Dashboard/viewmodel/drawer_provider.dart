import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/data/models/drawer_model.dart';

// Provider responsible for managing drawer state
class DrawerProvider with ChangeNotifier {
  // List of drawer menu items
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
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: Icons.trending_up,
      title: 'Revenue',
      navigation: AppRoutes.dashboard,
    ),
  ];
  // Stores currently selected drawer index
  int selectedIndex = 0;
  // Updates selected drawer item
  void selectedDrawerItem(int index) {
    selectedIndex = index;
    // Notify UI widgets (Consumer/Provider) to rebuild
    notifyListeners();
  }
}
