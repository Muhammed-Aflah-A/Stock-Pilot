import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class CategoryProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  CategoryProvider({required this.hiveService}) {
    loadCategory();
  }

  List<CategoryModel> categories = [];
  List<CategoryModel> filteredCategory = [];
  String _currentQuery = "";

  Future<void> loadCategory() async {
    categories = await hiveService.getAllCategories();
    _applySearch();
    notifyListeners();
  }

  void searchCategories(String query) {
    _currentQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    filteredCategory = SearchBarUtil.getFilteredList<CategoryModel>(
      sourceList: categories,
      query: _currentQuery,
      searchField: (categoryItem) => categoryItem.category ?? "",
    );
  }

  void clearSearch() {
    searchCategories("");
  }

  Future<void> addCategory(CategoryModel category) async {
    await hiveService.addCategory(category);
    await loadCategory();
  }

  Future<void> updateCategory(int index, CategoryModel category) async {
    await hiveService.updateCategory(index, category);
    await loadCategory();
  }

  Future<bool> canDeleteCategory(String categoryName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.category == categoryName);
  }

  Future<void> deleteCategory(int index) async {
    await hiveService.deleteCategory(index);
    await loadCategory();
  }
}
