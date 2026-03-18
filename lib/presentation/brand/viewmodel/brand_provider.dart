import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/service layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class BrandProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;

  BrandProvider({required this.hiveService}) {
    loadBrand();
  }
  // Full brand list
  List<BrandModel> brands = [];
  // Filtered list used for search results
  List<BrandModel> filteredBrands = [];
  // Current search query
  String _currentQuery = "";
  // Load brands from Hive
  Future<void> loadBrand() async {
    brands = await hiveService.getAllBrands();
    _applySearch();
    notifyListeners();
  }

  // Search brands
  void searchBrands(String query) {
    _currentQuery = query;
    _applySearch();
    notifyListeners();
  }

  // Apply search filtering
  void _applySearch() {
    filteredBrands = SearchBarUtil.getFilteredList<BrandModel>(
      sourceList: brands,
      query: _currentQuery,
      searchField: (brandItem) => brandItem.brand ?? "",
    );
  }

  // Clear search
  void clearSearch() {
    searchBrands("");
  }

  // Add new brand
  Future<void> addBrand(BrandModel brand, DashboardProvider dashboard) async {
    await hiveService.addBrand(brand);
    await loadBrand();
    // Update dashboard activity list
    await dashboard.loadActivities();
  }

  // Update brand and propagate change to products
  Future<void> updateBrand(
    int index,
    BrandModel brand,
    DashboardProvider dashboard,
  ) async {
    // Get old brand name
    final oldBrand = brands[index].brand ?? "";
    // Update brand in Hive
    await hiveService.updateBrand(index, brand);
    // Get all products
    final products = await hiveService.getAllProducts();
    // Update products using the old brand
    for (int i = 0; i < products.length; i++) {
      if (products[i].brand == oldBrand) {
        products[i].brand = brand.brand;
        await hiveService.updateProduct(i, products[i]);
      }
    }
    await loadBrand();
    await dashboard.loadActivities();
  }

  // Check if brand is used by products
  Future<bool> canDeleteBrand(String brandName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.brand == brandName);
  }

  // Delete brand
  Future<void> deleteBrand(int index, DashboardProvider dashboard) async {
    await hiveService.deleteBrand(index);
    await loadBrand();
    await dashboard.loadActivities();
  }
}
