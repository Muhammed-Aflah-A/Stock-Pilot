import 'package:flutter/widgets.dart';

class DashboardProvider with ChangeNotifier {
  List<Map<String, dynamic>> activities = [
    {
      'title': 'Stock Added',
      'product': 'AudioSound Pro',
      'category': 'Headphone',
      'units': 10,
      'label': 'units added',
      'isPositive': true,
    },
    {
      'title': 'Stock Sold',
      'product': 'Product',
      'category': 'Category',
      'units': 9,
      'label': 'units sold',
      'isPositive': false,
    },
    {
      'title': 'Stock Added',
      'product': 'Product',
      'category': 'Category',
      'units': 8,
      'label': 'units added',
      'isPositive': true,
    },
    {
      'title': 'Stock Sold',
      'product': 'Product',
      'category': 'Category',
      'units': 7,
      'label': 'units sold',
      'isPositive': false,
    },
    {
      'title': 'Stock Added',
      'product': 'Product',
      'category': 'Category',
      'units': 6,
      'label': 'units added',
      'isPositive': true,
    },
  ];

  void addNewActivity(Map<String, dynamic> activity) {
    activities.insert(0, activity);
    if (activities.length > 5) {
      activities.removeLast();
    }
    notifyListeners();
  }
}
