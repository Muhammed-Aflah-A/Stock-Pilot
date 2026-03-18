import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

// Sorting options available for product list
enum SortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

// Provider responsible for product managments
class ProductProvider extends FilterProviderInterface
    implements ImagePermissionHandler {
  // Hive service used to store and retrieve products
  final HiveServiceLayer hiveService;
  // Load products when provider is created
  ProductProvider({required this.hiveService}) {
    loadProducts();
  }
  // All products stored in database
  List<ProductModel> products = [];
  // Filtered product list used in UI
  List<ProductModel> filteredProducts = [];
  // Search query entered by user
  String searchQuery = "";
  // Form keys used for product form validation
  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();
  // Form field values
  String? productName;
  String? productDescription;
  String? brand;
  String? category;
  String? purchaseRate;
  String? salesRate;
  String? itemCount;
  String? lowStockCount;
  // Focus nodes for text field navigation
  final productDescriptionFocus = FocusNode();
  final salesRateFocus = FocusNode();
  final itemCountFocus = FocusNode();
  final lowStockCountFocus = FocusNode();
  // Product images used in add/edit form (max 4)
  List<File?> productImages = List.generate(4, (_) => null);
  // Currently editing product
  ProductModel? editingProduct;
  // Index of editing product
  int? editingIndex;
  // Returns true when editing an existing product
  bool get isEditing => editingProduct != null;
  // List of brands used in filter and dropdown
  @override
  List<String> brandsList = [];
  // Update brand list when dashboard brands change
  void setBrands(List<BrandModel> newBrands) {
    brandsList = newBrands.map((n) => n.brand ?? 'Unknown').toList();
    // Reset selected brand if it no longer exists
    if (brand != null && !brandsList.contains(brand)) {
      brand = null;
    }
    notifyListeners();
  }

  // List of categories used in filter and dropdown
  @override
  List<String> categoryList = [];
  // Update category list when dashboard categories change
  void setCategories(List<CategoryModel> newCategories) {
    categoryList = newCategories.map((n) => n.category ?? 'Unknown').toList();
    // Reset selected category if it no longer exists
    if (category != null && !categoryList.contains(category)) {
      category = null;
    }
    notifyListeners();
  }

  // Search products by product name
  void searchProducts(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Clear search query
  void clearSearch() {
    searchQuery = "";
    _applyFilters();
    notifyListeners();
  }

  // Handles permission for camera or gallery access
  @override
  Future<void> handleImagePermission({
    required BuildContext context,
    required bool isCamera,
    int? index,
  }) async {
    await PermissionUtil.handleImagePermission(
      context: context,
      provider: this,
      isCamera: isCamera,
      index: index,
    );
  }

  // Open camera and save captured image
  Future<void> openCamera([int? index]) async {
    final path = await ImageSelectorUtil.openCamera();
    if (path != null && index != null) {
      final savedPath = await ImageUtil.saveImage(File(path));
      productImages[index] = File(savedPath);
      notifyListeners();
    }
  }

  // Open gallery and save selected image
  Future<void> openLibrary([int? index]) async {
    final path = await ImageSelectorUtil.openLibrary();
    if (path != null && index != null) {
      final savedPath = await ImageUtil.saveImage(File(path));
      productImages[index] = File(savedPath);
      notifyListeners();
    }
  }

  // Remove selected image from form
  void removeImage(int index) {
    productImages[index] = null;
    notifyListeners();
  }

  /// Returns true if at least one image exists
  bool get hasImage => productImages.any((img) => img != null);

  /// Add new product to Hive database
  Future<void> addProduct(
    ProductModel product,
    DashboardProvider dashboard,
  ) async {
    await hiveService.addProduct(product);
    // Add activity log to dashboard
    final activity = DasboardActivity(
      image: product.productImages.isNotEmpty ? product.productImages[0] : null,
      title: 'Stock Added',
      product: product.productName,
      category: product.category,
      unit: int.tryParse(product.itemCount ?? '0') ?? 0,
      label: 'units added',
      isPositive: true,
    );
    dashboard.addNewActivity(activity);

    /// Reload product list
    await loadProducts();
  }

  // Load all products from Hive
  Future<void> loadProducts() async {
    products = await hiveService.getAllProducts();
    // Calculate maximum price for price filter slider
    final prices = products
        .map((p) => double.tryParse(p.salesRate ?? '0') ?? 0)
        .toList();
    if (prices.isNotEmpty) {
      final newMaxPrice = prices.reduce((a, b) => a > b ? a : b);
      maxPrice = newMaxPrice;
      selectedMaxPrice = maxPrice;
      tempMaxPrice = maxPrice;
    }
    _applyFilters();
    notifyListeners();
  }

  // Update existing product
  Future<void> updateProduct(
    int index,
    ProductModel newProduct,
    DashboardProvider dashboard,
  ) async {
    final oldProduct = products[index];
    final int oldCount = int.tryParse(oldProduct.itemCount ?? '0') ?? 0;
    final int newCount = int.tryParse(newProduct.itemCount ?? '0') ?? 0;
    await hiveService.updateProduct(index, newProduct);
    // Add dashboard activity if stock quantity changed
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

  // Delete product from Hive
  Future<void> deleteProduct(int index, DashboardProvider dashboard) async {
    final product = products[index];
    await hiveService.deleteProduct(index);
    // Add delete activity to dashboard
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

  // Current sorting option
  SortOption currentSort = SortOption.priceLowToHigh;

  // Change sorting type
  void sortProducts(SortOption option) {
    currentSort = option;
    _applySorting();
    notifyListeners();
  }

  // Apply sorting to filtered list
  void _applySorting() {
    filteredProducts.sort((a, b) {
      switch (currentSort) {
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

  // Selected filter values currently applied to product list
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};
  // Maximum price found in products (used for price slider)
  @override
  double maxPrice = 100000;
  // Currently selected price filter value
  double selectedMaxPrice = 100000;
  // Selected stock status filter
  String stockStatus = 'All';
  // Temporary filters used inside filter bottom sheet
  // These allow the user to adjust filters without immediately applying them
  @override
  Set<String> tempCategories = {};
  @override
  Set<String> tempBrands = {};
  @override
  double tempMaxPrice = 100000;
  @override
  String tempStockStatus = 'All';
  // Returns true if any filter is currently active
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      stockStatus != 'All';
  // Main filter pipeline
  // Applies search, category, brand, price, and stock filters
  void _applyFilters() {
    List<ProductModel> result = List.from(products);
    result = _applySearch(result);
    result = _applyCategoryFilter(result);
    result = _applyBrandFilter(result);
    result = _applyPriceFilter(result);
    result = _applyStockFilter(result);
    filteredProducts = result;
    // Apply sorting after filtering
    _applySorting();
  }

  // Filter products based on search query
  List<ProductModel> _applySearch(List<ProductModel> list) {
    if (searchQuery.isEmpty) return list;
    return list.where((n) {
      return (n.productName ?? '').toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
    }).toList();
  }

  // Filter products by selected categories
  List<ProductModel> _applyCategoryFilter(List<ProductModel> list) {
    if (selectedCategories.isEmpty) return list;
    return list.where((n) {
      return selectedCategories.contains(n.category);
    }).toList();
  }

  // Filter products by selected brands
  List<ProductModel> _applyBrandFilter(List<ProductModel> list) {
    if (selectedBrands.isEmpty) return list;
    return list.where((n) {
      return selectedBrands.contains(n.brand);
    }).toList();
  }

  // Filter products based on maximum selected price
  List<ProductModel> _applyPriceFilter(List<ProductModel> list) {
    return list.where((n) {
      final price = double.tryParse(n.salesRate ?? '0') ?? 0;
      return price <= selectedMaxPrice;
    }).toList();
  }

  // Filter products based on stock status
  List<ProductModel> _applyStockFilter(List<ProductModel> list) {
    if (stockStatus == 'All') return list;
    return list.where((p) {
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

  // Initialize temporary filters when filter sheet opens
  // Copies currently applied filters to temp variables
  @override
  void initTempFilters() {
    tempCategories = Set.from(selectedCategories);
    tempBrands = Set.from(selectedBrands);
    tempMaxPrice = selectedMaxPrice;
    tempStockStatus = stockStatus;
    notifyListeners();
  }

  // Toggle category selection inside filter sheet
  @override
  void toggleTempCategory(String cat) {
    tempCategories = Set.from(tempCategories);
    tempCategories.contains(cat)
        ? tempCategories.remove(cat)
        : tempCategories.add(cat);
    notifyListeners();
  }

  // Toggle brand selection inside filter sheet
  @override
  void toggleTempBrand(String brand) {
    tempBrands = Set.from(tempBrands);
    tempBrands.contains(brand)
        ? tempBrands.remove(brand)
        : tempBrands.add(brand);
    notifyListeners();
  }

  // Update temporary max price from slider
  @override
  void setTempMaxPrice(double value) {
    tempMaxPrice = value;
    notifyListeners();
  }

  // Update temporary stock status
  @override
  void setTempStockStatus(String status) {
    tempStockStatus = status;
    notifyListeners();
  }

  // Apply temporary filters to actual filters
  @override
  void applyFilters() {
    selectedCategories = Set.from(tempCategories);
    selectedBrands = Set.from(tempBrands);
    selectedMaxPrice = tempMaxPrice;
    stockStatus = tempStockStatus;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters and reset to default
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

  // Prepare provider state for editing a product
  // Loads product data into form fields
  void setEditingProduct(ProductModel product, int index) {
    // Reset image list
    productImages = List.generate(4, (_) => null);
    // Load product images from stored paths
    for (int i = 0; i < product.productImages.length && i < 4; i++) {
      productImages[i] = File(product.productImages[i]);
    }
    editingProduct = product;
    editingIndex = index;
    // Fill form fields with existing product data
    productName = product.productName;
    productDescription = product.productDescription;
    brand = product.brand;
    category = product.category;
    purchaseRate = product.purchaseRate;
    salesRate = product.salesRate;
    itemCount = product.itemCount;
    lowStockCount = product.lowStockCount;
    notifyListeners();
  }

  // Clear editing state after edit completes
  void clearEditing() {
    editingProduct = null;
    editingIndex = null;
    notifyListeners();
  }

  // Reset product form fields after add/edit
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
    // Reset form validation states
    firstFormKey.currentState?.reset();
    secondFormKey.currentState?.reset();
    notifyListeners();
  }

  // Returns color representing stock status
  Color getStockColor(ProductModel product) {
    final count = int.tryParse(product.itemCount ?? '0') ?? 0;
    final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
    if (count == 0) {
      return ColourStyles.colorRed;
    } else if (count <= lowStock) {
      return ColourStyles.colorYellow;
    } else {
      return ColourStyles.colorGreen;
    }
  }

  // Returns stock status text shown in UI
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
}
