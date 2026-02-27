import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class BrandProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  BrandProvider({required this.hiveService}) {
    loadBrand();
  }
  List<BrandModel> brands = [];
  List<BrandModel> filteredBrands = [];
  String _currentQuery = "";
  Future<void> addBrand(BrandModel brandName) async {
    await hiveService.addBrand(brandName);
    await loadBrand();
  }

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

  Future<void> updateBrand(int index, BrandModel brand) async {
    await hiveService.updateBrand(index, brand);
    await loadBrand();
  }

  Future<bool> canDeleteBrand(String brandName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.brand == brandName);
  }

  Future<void> deleteBrand(int index) async {
    await hiveService.deleteBrand(index);
    await loadBrand();
  }
}
