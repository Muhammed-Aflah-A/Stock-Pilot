import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/service layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

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

  String? validateCategory(String value, {String? currentCategory}) {
    if (currentCategory != null &&
        value.trim().toLowerCase() == currentCategory.toLowerCase()) {
      return null;
    }
    final exists = categories.any(
      (c) => c.category?.toLowerCase() == value.trim().toLowerCase(),
    );
    return exists ? "Category already exists" : null;
  }

  void onAddCategoryClicked(BuildContext context, DashboardProvider dashboard) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDetailsWidget(
          maxLength: 30,
          title: "Category",
          fieldType: "category",
          isEditing: false,
          duplicateValidator: (value) => validateCategory(value),
          onSave: (value) async {
            final newCategory = CategoryModel(category: value);
            await addCategory(newCategory, dashboard);
          },
        );
      },
    );
  }

  void onEditCategoryClicked(
    BuildContext context,
    CategoryModel categoryItem,
    DashboardProvider dashboard,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditDetailsWidget(
        maxLength: 30,
        title: "Category",
        fieldType: "category",
        initialValue: categoryItem.category,
        isEditing: true,
        duplicateValidator: (value) =>
            validateCategory(value, currentCategory: categoryItem.category),
        onSave: (value) async {
          final updatedCategory = CategoryModel(category: value);
          final realIndex = categories.indexOf(categoryItem);
          if (realIndex != -1) {
            await updateCategory(realIndex, updatedCategory, dashboard);
          }
        },
      ),
    );
  }

  void onDeleteCategoryClicked(
    BuildContext context,
    CategoryModel categoryItem,
    DashboardProvider dashboard,
  ) {
    showDialog(
      context: context,
      builder: (context) => ActionConfirmationWidget(
        title: "Remove Category",
        displayName: categoryItem.category ?? "",
        actionText: "Remove",
        actionColor: ColourStyles.colorRed,
        onConfirm: () async {
          final canDelete = await canDeleteCategory(
            categoryItem.category ?? "",
          );
          if (!context.mounted) {
            return false;
          }
          if (!canDelete) {
            Navigator.pop(context);
            SnackbarUtil.showSnackBar(
              context,
              '"${categoryItem.category}" is used by one or more products and cannot be deleted',
              true,
            );
            return false;
          }
          final realIndex = categories.indexOf(categoryItem);
          if (realIndex != -1) {
            await deleteCategory(realIndex, dashboard);
          }
          return true;
        },
      ),
    );
  }
}
