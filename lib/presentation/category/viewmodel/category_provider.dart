import 'package:flutter/material.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class CategoryProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  CategoryProvider({required this.hiveService}) {
    loadCategories();
  }
  List<CategoryModel> categories = [];
  Future<void> addCategory(CategoryModel categoryName) async {
    await hiveService.addCategory(categoryName);
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await hiveService.getAllCategories();
    notifyListeners();
  }

  Future<void> updateCategory(int index, CategoryModel category) async {
    await hiveService.updateCategory(index, category);
    await loadCategories();
  }

  Future<void> deleteCategory(int index) async {
    await hiveService.deleteCategory(index);
    await loadCategories();
  }
}
