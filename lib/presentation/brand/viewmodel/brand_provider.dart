import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/service layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

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

  String? validateBrand(String value, {String? currentBrand}) {
    if (currentBrand != null &&
        value.trim().toLowerCase() == currentBrand.toLowerCase()) {
      return null;
    }
    final exists = brands.any(
      (b) => b.brand?.toLowerCase() == value.trim().toLowerCase(),
    );
    return exists ? "Brand already exists" : null;
  }

  void onAddBrandClicked(BuildContext context, DashboardProvider dashboard) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDetailsWidget(
          maxLength: 30,
          title: "Brand",
          fieldType: "brand",
          isEditing: false,
          duplicateValidator: (value) => validateBrand(value),
          onSave: (value) async {
            final newBrand = BrandModel(brand: value);
            await addBrand(newBrand, dashboard);
          },
        );
      },
    );
  }

  void onEditBrandClicked(
    BuildContext context,
    BrandModel brandItem,
    DashboardProvider dashboard,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditDetailsWidget(
        maxLength: 30,
        title: "Brand",
        fieldType: "brand",
        initialValue: brandItem.brand,
        isEditing: true,
        duplicateValidator: (value) =>
            validateBrand(value, currentBrand: brandItem.brand),
        onSave: (value) async {
          final updatedBrand = BrandModel(brand: value);
          final realIndex = brands.indexOf(brandItem);
          if (realIndex != -1) {
            await updateBrand(realIndex, updatedBrand, dashboard);
          }
        },
      ),
    );
  }

  void onDeleteBrandClicked(
    BuildContext context,
    BrandModel brandItem,
    DashboardProvider dashboard,
  ) {
    showDialog(
      context: context,
      builder: (context) => ActionConfirmationWidget(
        title: "Remove Brand",
        displayName: brandItem.brand ?? "",
        actionText: "Remove",
        actionColor: ColourStyles.colorRed,
        onConfirm: () async {
          final canDelete = await canDeleteBrand(brandItem.brand ?? "");
          if (!context.mounted) {
            return false;
          }
          if (!canDelete) {
            Navigator.pop(context);
            SnackbarUtil.showSnackBar(
              context,
              '"${brandItem.brand}" is used by one or more products and cannot be deleted',
              true,
            );
            return false;
          }
          final realIndex = brands.indexOf(brandItem);
          if (realIndex != -1) {
            await deleteBrand(realIndex, dashboard);
          }
          return true;
        },
      ),
    );
  }
}
