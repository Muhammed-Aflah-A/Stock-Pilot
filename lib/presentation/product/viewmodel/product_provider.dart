import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

enum SortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class ProductProvider extends FilterProviderInterface {
  final ImageSelectorUtil imageSelector;
  final HiveServiceLayer hiveService;

  ProductProvider({required this.imageSelector, required this.hiveService}) {
    loadProducts();
  }
  List<ProductModel> filteredProducts = [];
  String _searchQuery = "";
  List<ProductModel> filteredLowStock = [];
  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();
  List<File?> productImages = List.generate(4, (_) => null);
  String? productName;
  final productDescriptionFocus = FocusNode();
  String? productDescription;

  @override
  List<String> brandsList = [];
  void brands(List<BrandModel> newBrands) {
    brandsList = newBrands.map((e) => e.brand ?? 'Unknown').toList();
    if (brand != null && !brandsList.contains(brand)) {
      brand = null;
    }
    notifyListeners();
  }
  String? brand;
  @override
  List<String> categoryList = [];
  void categories(List<CategoryModel> newCategories) {
    categoryList = newCategories.map((e) => e.category ?? 'Unknown').toList();
    if (category != null && !categoryList.contains(category)) {
      category = null;
    }
    notifyListeners();
  }

  String? category;
  String? purchaseRate;
  final salesRateFocus = FocusNode();
  String? salesRate;
  final itemCountFocus = FocusNode();
  String? itemCount;
  final lowStockCountFocus = FocusNode();
  String? lowStockCount;
  List<ProductModel> products = [];
  int currentCarouselIndex = 0;

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = "";
    _applyFilters();
    notifyListeners();
  }

  Future<void> openCamera([int? index]) async {
    final path = await imageSelector.openCamera();
    if (path != null) {
      if (index != null) {
        productImages[index] = File(path);
      }
      notifyListeners();
    }
  }

  Future<void> openLibrary([int? index]) async {
    final path = await imageSelector.openLibrary();
    if (path != null) {
      if (index != null) {
        productImages[index] = File(path);
      }
      notifyListeners();
    }
  }

  void removeImage(int index) {
    productImages[index] = null;
    notifyListeners();
  }
  bool get hasImage => productImages.any((img) => img != null);

  Future<void> addproduct(
    ProductModel product,
    DashboardProvider dashboard,
  ) async {
    await hiveService.addProduct(product);
    final activity = DasboardActivity(
      image: product.productImages.isNotEmpty
          ? product.productImages[0]
          : AppImages.productImage1,
      title: 'Stock Added',
      product: product.productName,
      category: product.category,
      unit: int.tryParse(product.itemCount ?? '0') ?? 0,
      label: 'units added',
      isPositive: true,
    );
    dashboard.addNewActivity(activity);
    await loadProducts();
  }

  Future<void> loadProducts() async {
    products = await hiveService.getAllProducts();
    final prices = products
        .map((p) => double.tryParse(p.salesRate ?? '0') ?? 0)
        .toList();
    if (prices.isNotEmpty) {
      maxPrice = prices.reduce((a, b) => a > b ? a : b);
      if (selectedMaxPrice > maxPrice) selectedMaxPrice = maxPrice;
      if (tempMaxPrice > maxPrice) tempMaxPrice = maxPrice;
    }
    _applyFilters();
    notifyListeners();
  }

  Color getStockColor(ProductModel product) {
    final count = int.tryParse(product.itemCount!) ?? 0;
    final lowStock = int.tryParse(product.lowStockCount!) ?? 0;
    if (count == 0) {
      return ColourStyles.colorRed;
    } else if (count <= lowStock) {
      return ColourStyles.colorYellow;
    } else {
      return ColourStyles.colorGreen;
    }
  }

  String getStockText(ProductModel product) {
    final count = int.tryParse(product.itemCount ?? '0') ?? 0;
    final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
    if (count == 0) {
      return 'Out of stock : $count';
    } else if (count <= lowStock) {
      return 'Low stock : $count';
    } else {
      return 'In stock : $count';
    }
  }

  void updateCarouselIndex(int index) {
    currentCarouselIndex = index;
    notifyListeners();
  }

  void loadProductForEdit(ProductModel product) {
    productName = product.productName;
    productDescription = product.productDescription;
    brand = product.brand;
    category = product.category;
    purchaseRate = product.purchaseRate;
    salesRate = product.salesRate;
    itemCount = product.itemCount;
    lowStockCount = product.lowStockCount;
    productImages = List.generate(4, (_) => null);
    for (int i = 0; i < product.productImages.length && i < 4; i++) {
      productImages[i] = File(product.productImages[i]);
    }
    notifyListeners();
  }

  Future<void> updateProduct(
    int index,
    ProductModel newProduct,
    DashboardProvider dashboard,
  ) async {
    final oldProduct = products[index];
    final int oldCount = int.tryParse(oldProduct.itemCount ?? '0') ?? 0;
    final int newCount = int.tryParse(newProduct.itemCount ?? '0') ?? 0;
    await hiveService.updateProduct(index, newProduct);
    if (oldCount != newCount) {
      final int difference = (newCount - oldCount).abs();
      final bool isAddition = newCount > oldCount;
      final activity = DasboardActivity(
        image: newProduct.productImages.isNotEmpty
            ? newProduct.productImages[0]
            : AppImages.productImage1,
        title: isAddition ? 'Stock Increased' : 'Stock Decreased',
        product: newProduct.productName,
        category: newProduct.category,
        unit: difference,
        label: isAddition ? 'units added' : 'units removed',
        isPositive: isAddition,
      );
      dashboard.addNewActivity(activity);
    }
    await loadProducts();
  }

  Future<void> deleteProduct(int index, DashboardProvider dashboard) async {
    final product = products[index];
    await hiveService.deleteProduct(index);
    final activity = DasboardActivity(
      image: (product.productImages.isNotEmpty)
          ? product.productImages[0]
          : AppImages.productImage1,
      title: 'Stock Deleted',
      product: product.productName,
      category: product.category,
      unit: int.tryParse(product.itemCount ?? '0') ?? 0,
      label: 'units removed',
      isPositive: false,
    );
    dashboard.addNewActivity(activity);
    await loadProducts();
  }

  void resetForm() {
    productImages = List.generate(4, (_) => null);
    productName = null;
    productDescription = null;
    itemCount = null;
    lowStockCount = null;
    brand = null;
    category = null;
    purchaseRate = null;
    salesRate = null;
    firstFormKey.currentState?.reset();
    secondFormKey.currentState?.reset();
    notifyListeners();
  }
  SortOption _currentSort = SortOption.priceLowToHigh;
  SortOption get currentSort => _currentSort;
  void sortProducts(SortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    filteredProducts.sort((a, b) {
      switch (_currentSort) {
        case SortOption.priceLowToHigh:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
          return aPrice.compareTo(bPrice);
        case SortOption.priceHighToLow:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
          return bPrice.compareTo(aPrice);
        case SortOption.alphabeticalAZ:
          return (a.productName ?? '').toLowerCase().compareTo(
            (b.productName ?? '').toLowerCase(),
          );
        case SortOption.alphabeticalZA:
          return (b.productName ?? '').toLowerCase().compareTo(
            (a.productName ?? '').toLowerCase(),
          );
      }
    });
  }
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};
  @override
  double maxPrice = 5000;
  double selectedMaxPrice = 5000;
  String stockStatus = 'All';
  @override
  Set<String> tempCategories = {};
  @override
  Set<String> tempBrands = {};
  @override
  double tempMaxPrice = 5000;
  @override
  String tempStockStatus = 'All';
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      stockStatus != 'All';

  @override
  void initTempFilters() {
    tempCategories = Set.from(selectedCategories);
    tempBrands = Set.from(selectedBrands);
    tempMaxPrice = selectedMaxPrice;
    tempStockStatus = stockStatus;
    notifyListeners();
  }

  @override
  void toggleTempCategory(String cat) {
    tempCategories = Set.from(tempCategories);
    tempCategories.contains(cat)
        ? tempCategories.remove(cat)
        : tempCategories.add(cat);
    notifyListeners();
  }

  @override
  void toggleTempBrand(String brand) {
    tempBrands = Set.from(tempBrands);
    tempBrands.contains(brand)
        ? tempBrands.remove(brand)
        : tempBrands.add(brand);
    notifyListeners();
  }

  @override
  void setTempMaxPrice(double value) {
    tempMaxPrice = value;
    notifyListeners();
  }

  @override
  void setTempStockStatus(String status) {
    tempStockStatus = status;
    notifyListeners();
  }

  @override
  void applyFilters() {
    selectedCategories = Set.from(tempCategories);
    selectedBrands = Set.from(tempBrands);
    selectedMaxPrice = tempMaxPrice;
    stockStatus = tempStockStatus;
    _applyFilters();
    notifyListeners();
  }

  @override
  void clearFilters() {
    selectedCategories = {};
    selectedBrands = {};
    selectedMaxPrice = maxPrice;
    stockStatus = 'All';
    tempCategories = {};
    tempBrands = {};
    tempMaxPrice = maxPrice;
    tempStockStatus = 'All';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<ProductModel> result = List.from(products);
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (p) => (p.productName ?? '').toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    if (selectedCategories.isNotEmpty) {
      result = result
          .where((p) => selectedCategories.contains(p.category))
          .toList();
    }
    if (selectedBrands.isNotEmpty) {
      result = result.where((p) => selectedBrands.contains(p.brand)).toList();
    }
    result = result.where((p) {
      final price = double.tryParse(p.salesRate ?? '0') ?? 0;
      return price <= selectedMaxPrice;
    }).toList();
    if (stockStatus != 'All') {
      result = result.where((p) {
        final count = int.tryParse(p.itemCount ?? '0') ?? 0;
        final low = int.tryParse(p.lowStockCount ?? '0') ?? 0;
        switch (stockStatus) {
          case 'In Stock':
            return count > low;
          case 'Low Stock':
            return count > 0 && count <= low;
          case 'Out of Stock':
            return count == 0;
          default:
            return true;
        }
      }).toList();
    }
    filteredProducts = result;
    _applySorting();
  }
}
