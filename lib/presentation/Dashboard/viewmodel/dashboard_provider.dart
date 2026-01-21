import 'package:flutter/widgets.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';

class DashboardProvider with ChangeNotifier {
  List<DashboardCards> dashboardCards = [
    DashboardCards(
      title: "Total Items",
      value: "1250",
    ),
    DashboardCards(
      title: "Total Value",
      value: "\$150k",
    ),
    DashboardCards(
      title: "Total Category",
      value: "4",
    ),
    DashboardCards(
      title: "Total Brand",
      value: "4",
    ),
    DashboardCards(
      title: "Purchase Cost",
      value: "\$100k",
    ),
    DashboardCards(
      title: "Monthly Turnover",
      value: "\$50k",
    ),
    DashboardCards(
      title: "Low Stock",
      value: "5",
    ),
    DashboardCards(
      title: "Out of Stock",
      value: "1",
    ),
  ];
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
  void addNewActivity(DasboardActivity activity) {
    dashboardActivity.insert(0, activity);
    if (dashboardActivity.length > 5) {
      dashboardActivity.removeLast();
    }
    notifyListeners();
  }
}
