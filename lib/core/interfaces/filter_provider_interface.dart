import 'package:flutter/material.dart';

// Interface for the filter provider.
// Any concrete filter provider must implement this interface.
abstract class FilterProviderInterface extends ChangeNotifier {
  bool get hasActiveFilters;
  double get maxPrice;
  double get minPrice;
  double get tempMaxPrice;
  double get tempMinPrice;
  String get tempStockStatus;
  Set<String> get tempCategories;
  Set<String> get tempBrands;
  List<String> get categoryList;
  List<String> get brandsList;
  bool get showStockFilter => true;
  List<String> get availableStockStatuses;
  bool get showPriceFilter;
  bool get showCategoryFilter;
  bool get showBrandFilter;

  void initTempFilters();
  void toggleTempCategory(String cat);
  void toggleTempBrand(String brand);
  void setTempPriceRange(double min, double max);
  void setTempStockStatus(String status);
  void applyFilters();
  void clearFilters();
}
