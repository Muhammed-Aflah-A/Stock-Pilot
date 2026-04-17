import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/service layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

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

  Future<void> addCategory(
    CategoryModel category,
    DashboardProvider dashboard,
  ) async {
    await hiveService.addCategory(category);
    await loadCategory();
    await dashboard.loadActivities();
  }

  Future<void> updateCategory(
    int index,
    CategoryModel category,
    DashboardProvider dashboard,
  ) async {
    final oldCategory = categories[index].category ?? "";
    await hiveService.updateCategory(index, category);
    final products = await hiveService.getAllProducts();
    for (int i = 0; i < products.length; i++) {
      if (products[i].category == oldCategory) {
        products[i].category = category.category;
        await hiveService.updateProduct(i, products[i]);
      }
    }
    await loadCategory();
    await dashboard.loadActivities();
  }

  Future<bool> canDeleteCategory(String categoryName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.category == categoryName);
  }

  Future<void> deleteCategory(int index, DashboardProvider dashboard) async {
    await hiveService.deleteCategory(index);
    await loadCategory();
    await dashboard.loadActivities();
  }
}

