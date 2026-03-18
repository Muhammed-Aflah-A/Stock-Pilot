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

  // Full category list
  List<CategoryModel> categories = [];
  // Filtered list used for search results
  List<CategoryModel> filteredCategory = [];
  // Current search query
  String _currentQuery = "";

  // Load categories from Hive
  Future<void> loadCategory() async {
    categories = await hiveService.getAllCategories();
    _applySearch();
    notifyListeners();
  }

  // Search categories
  void searchCategories(String query) {
    _currentQuery = query;
    _applySearch();
    notifyListeners();
  }

  // Apply search filtering
  void _applySearch() {
    filteredCategory = SearchBarUtil.getFilteredList<CategoryModel>(
      sourceList: categories,
      query: _currentQuery,
      searchField: (categoryItem) => categoryItem.category ?? "",
    );
  }

  // Clear search
  void clearSearch() {
    searchCategories("");
  }

  // Add category
  Future<void> addCategory(
    CategoryModel category,
    DashboardProvider dashboard,
  ) async {
    await hiveService.addCategory(category);
    await loadCategory();
    // Update dashboard activity list
    await dashboard.loadActivities();
  }

  // Update category and propagate change to products
  Future<void> updateCategory(
    int index,
    CategoryModel category,
    DashboardProvider dashboard,
  ) async {
    // Get the old category name
    final oldCategory = categories[index].category ?? "";
    // Update category in Hive
    await hiveService.updateCategory(index, category);
    // Get all products
    final products = await hiveService.getAllProducts();
    // Update products that used the old category
    for (int i = 0; i < products.length; i++) {
      if (products[i].category == oldCategory) {
        products[i].category = category.category;
        await hiveService.updateProduct(i, products[i]);
      }
    }
    await loadCategory();
    await dashboard.loadActivities();
  }

  // Check if category is used by products
  Future<bool> canDeleteCategory(String categoryName) async {
    final products = await hiveService.getAllProducts();
    return !products.any((p) => p.category == categoryName);
  }

  // Delete category
  Future<void> deleteCategory(int index, DashboardProvider dashboard) async {
    await hiveService.deleteCategory(index);
    await loadCategory();
    await dashboard.loadActivities();
  }
}
