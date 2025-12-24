// Flutter widgets package
// Used here for ChangeNotifier
import 'package:flutter/widgets.dart';

// App icon paths/constants
import 'package:stock_pilot/core/assets/app_icons.dart';

// App route names used for navigation
import 'package:stock_pilot/core/navigation/app_routes.dart';

// Drawer item model
import 'package:stock_pilot/data/models/drawer_model.dart';

/// DrawerProvider
/// This provider manages:
/// - Drawer menu items
/// - Currently selected drawer item index
/// - Notifies UI when selection changes
class DrawerProvider with ChangeNotifier {
  // List of drawer menu items shown in the navigation drawer
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

  // Index of the currently selected drawer item
  int selectedIndex = 0;

  /// Updates the selected drawer item
  /// Notifies listeners so UI can update selection state
  void selectedDrawerItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
