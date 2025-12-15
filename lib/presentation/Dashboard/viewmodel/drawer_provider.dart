import 'package:flutter/widgets.dart';
import 'package:stock_pilot/core/assets/app_icons.dart';
import 'package:stock_pilot/data/models/drawer_items_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class DrawerProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  DrawerProvider({required this.hiveService}) {
    loadUser();
  }
  UserProfile? user;
  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

  final List<DrawerItems> drawerItems = [
    DrawerItems(
      title: 'Profile',
      icon: AppIcons.userAvatar,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'Dashboard',
      icon: AppIcons.dashboard,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'Products',
      icon: AppIcons.product,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'Category',
      icon: AppIcons.category,
      navigation: "/dashboard",
    ),
    DrawerItems(title: 'Brand', icon: AppIcons.brand, navigation: "/dashboard"),
    DrawerItems(
      title: 'Low stock',
      icon: AppIcons.lowStock,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'Out of stock',
      icon: AppIcons.outOfStock,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'History',
      icon: AppIcons.history,
      navigation: "/dashboard",
    ),
    DrawerItems(
      title: 'Revenue',
      icon: AppIcons.revenue,
      navigation: "/dashboard",
    ),
  ];

  int selectedIndex = 0;

  void selectedDrawerItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
