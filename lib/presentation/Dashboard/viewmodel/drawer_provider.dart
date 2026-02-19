import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/drawer_model.dart';

class DrawerProvider with ChangeNotifier {
  final List<DrawerItems> drawerItems = [
    DrawerItems(
      icon: Icon(Icons.person, color: ColourStyles.primaryColor_2),
      title: 'Profile',
      navigation: AppRoutes.profilePage,
    ),
    DrawerItems(
      icon: Icon(Icons.space_dashboard, color: ColourStyles.primaryColor_2),
      title: 'Dashboard',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: Icon(Icons.inventory_2, color: ColourStyles.primaryColor_2),
      title: 'Products',
      navigation: AppRoutes.productListPage,
    ),
    DrawerItems(
      icon: Icon(Icons.sell, color: ColourStyles.primaryColor_2),
      title: 'Brand',
      navigation: AppRoutes.brand,
    ),
    DrawerItems(
      icon: Icon(Icons.category, color: ColourStyles.primaryColor_2),
      title: 'Category',
      navigation: AppRoutes.category,
    ),
    DrawerItems(
      icon: Icon(Icons.warning_amber, color: ColourStyles.primaryColor_2),
      title: 'Low stock',
      navigation: AppRoutes.lowStockPage,
    ),
    DrawerItems(
      icon: Icon(Icons.cancel, color: ColourStyles.primaryColor_2),
      title: 'Out of stock',
      navigation: AppRoutes.outOfStockPage,
    ),
    DrawerItems(
      icon: Icon(Icons.shopping_cart, color: ColourStyles.primaryColor_2),
      title: 'Cart',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: Icon(Icons.history, color: ColourStyles.primaryColor_2),
      title: 'History',
      navigation: AppRoutes.dashboard,
    ),
    DrawerItems(
      icon: Icon(Icons.trending_up, color: ColourStyles.primaryColor_2),
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
