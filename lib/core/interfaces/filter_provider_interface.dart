import 'package:flutter/material.dart';

// Interface for the filter provider.
// Any concrete filter provider must implement this interface.
abstract class FilterProviderInterface extends ChangeNotifier {
  bool get hasActiveFilters;
  double get maxPrice;
  double get tempMaxPrice;
  String get tempStockStatus;
  Set<String> get tempCategories;
  Set<String> get tempBrands;
  List<String> get categoryList;
  List<String> get brandsList;
  bool get showStockFilter => true;

  void initTempFilters();
  void toggleTempCategory(String cat);
  void toggleTempBrand(String brand);
  void setTempMaxPrice(double value);
  void setTempStockStatus(String status);
  void applyFilters();
  void clearFilters();
}
