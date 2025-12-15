import 'package:flutter/widgets.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';

class DashboardProvider with ChangeNotifier {
  List<DasboardModel> activities = [
    DasboardModel(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 10,
      label: 'units added',
      isPositive: true,
    ),
    DasboardModel(
      image: AppImages.productImage1,
      title: 'Stock Sold',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 9,
      label: 'units sold',
      isPositive: false,
    ),
    DasboardModel(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 8,
      label: 'units added',
      isPositive: true,
    ),
    DasboardModel(
      image: AppImages.productImage1,
      title: 'Stock Sold',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 7,
      label: 'units sold',
      isPositive: false,
    ),
    DasboardModel(
      image: AppImages.productImage1,
      title: 'Stock Added',
      product: 'AudioSound Pro',
      category: 'Headphone',
      unit: 6,
      label: 'units added',
      isPositive: true,
    ),
  ];

  void addNewActivity(DasboardModel activity) {
    activities.insert(0, activity);
    if (activities.length > 5) {
      activities.removeLast();
    }
    notifyListeners();
  }
}
