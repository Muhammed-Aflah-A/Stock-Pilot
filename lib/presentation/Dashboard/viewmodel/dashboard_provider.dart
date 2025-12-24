// Flutter widgets package
// Used here for ChangeNotifier
import 'package:flutter/widgets.dart';

// App image assets
import 'package:stock_pilot/core/assets/app_images.dart';

// App text styles
import 'package:stock_pilot/core/theme/text_styles.dart';

// Dashboard data models
import 'package:stock_pilot/data/models/dasboard_model.dart';

/// DashboardProvider
/// This provider manages all data shown on the dashboard:
/// - Summary cards (top grid)
/// - Recent activity list
/// - Notifies UI when data changes
class DashboardProvider with ChangeNotifier {
  // ================= DASHBOARD SUMMARY CARDS =================
  // List of cards displayed at the top of the dashboard
  List<DashboardCards> dashboardCards = [
    DashboardCards(
      title: "Total Items",
      value: "1250",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.primaryText_3,
    ),
    DashboardCards(
      title: "Total Value",
      value: "\$150k",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.primaryText_3,
    ),
    DashboardCards(
      title: "Total Category",
      value: "4",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.primaryText_3,
    ),
    DashboardCards(
      title: "Total Brand",
      value: "4",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.primaryText_3,
    ),
    DashboardCards(
      title: "Purchase Cost",
      value: "\$100k",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.primaryText_3,
    ),
    DashboardCards(
      title: "Monthly Turnover",
      value: "\$50k",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.turnOver,
    ),
    DashboardCards(
      title: "Low Stock",
      value: "5",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.lowStock,
    ),
    DashboardCards(
      title: "Out of Stock",
      value: "1",
      titleStyle: TextStyles.primaryText_2,
      valueStyle: TextStyles.outOfStock,
    ),
  ];

  // ================= RECENT ACTIVITY LIST =================
  // List of recent stock activities shown on the dashboard
  List<DasboardActivity> dashboardActivity = [
    DasboardActivity(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 10,
      label: 'units added',
      isPositive: true,
    ),
    DasboardActivity(
      image: AppImages.productImage1,
      title: 'Stock Sold',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 9,
      label: 'units sold',
      isPositive: false,
    ),
    DasboardActivity(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 8,
      label: 'units added',
      isPositive: true,
    ),
    DasboardActivity(
      image: AppImages.productImage1,
      title: 'Stock Sold',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 7,
      label: 'units sold',
      isPositive: false,
    ),
    DasboardActivity(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 6,
      label: 'units added',
      isPositive: true,
    ),
  ];

  /// Adds a new activity to the top of the list
  /// Keeps only the latest 5 activities
  /// Notifies listeners so UI updates automatically
  void addNewActivity(DasboardActivity activity) {
    // Insert new activity at the beginning
    dashboardActivity.insert(0, activity);

    // Remove last item if list exceeds 5 items
    if (dashboardActivity.length > 5) {
      dashboardActivity.removeLast();
    }

    // Notify UI to rebuild
    notifyListeners();
  }
}
