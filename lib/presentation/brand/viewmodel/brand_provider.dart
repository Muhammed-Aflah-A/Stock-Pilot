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
  List<BrandModel> brands = [];
  List<BrandModel> filteredBrands = [];
  String _currentQuery = "";
  Future<void> loadBrand() async {
    brands = await hiveService.getAllBrands();
    _applySearch();
    notifyListeners();
  }

  void searchBrands(String query) {
    _currentQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    filteredBrands = SearchBarUtil.getFilteredList<BrandModel>(
      sourceList: brands,
      query: _currentQuery,
      searchField: (brandItem) => brandItem.brand ?? "",
    );
  }

  void clearSearch() {
    searchBrands("");
  }

  Future<void> addBrand(BrandModel brand, DashboardProvider dashboard) async {
    await hiveService.addBrand(brand);
    await loadBrand();
    await dashboard.loadActivities();
  }

  Future<void> updateBrand(
    int index,
    BrandModel brand,
    DashboardProvider dashboard,
  ) async {
    final oldBrand = brands[index].brand ?? "";
    await hiveService.updateBrand(index, brand);
    final products = await hiveService.getAllProducts();
    for (int i = 0; i < products.length; i++) {
      if (products[i].brand == oldBrand) {
        products[i].brand = brand.brand;
        await hiveService.updateProduct(i, products[i]);
      }
    }
    await loadBrand();
    await dashboard.loadActivities();
  }

  Future<bool> canDeleteBrand(String brandName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.brand == brandName);
  }

  Future<void> deleteBrand(int index, DashboardProvider dashboard) async {
    await hiveService.deleteBrand(index);
    await loadBrand();
    await dashboard.loadActivities();
  }
}
