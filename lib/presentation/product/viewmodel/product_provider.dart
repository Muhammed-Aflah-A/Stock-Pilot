import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/utils/crop_image_util.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:intl/intl.dart';
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
  // Index of the currently viewed product in ProductDetailsPage
  int? activeProductIndex;
  
  // Set the active product for detailed viewing
  void setActiveProductIndex(int index) {
    activeProductIndex = index;
    notifyListeners();
  }
  
  // Returns true when editing an existing product
  bool get isEditing => editingProduct != null;
  // List of brands used in dropdown
  List<String> fullBrandsList = [];
  // Update brand list when dashboard brands change
  void setBrands(List<BrandModel> newBrands) {
    fullBrandsList = newBrands.map((n) => n.brand ?? 'Unknown').toList();
    // Reset selected brand if it no longer exists
    if (brand != null && !fullBrandsList.contains(brand)) {
      brand = null;
    }
    notifyListeners();
  }

  // List of categories used in dropdown
  List<String> fullCategoryList = [];
  // Update category list when dashboard categories change
  void setCategories(List<CategoryModel> newCategories) {
    fullCategoryList = newCategories.map((n) => n.category ?? 'Unknown').toList();
    // Reset selected category if it no longer exists
    if (category != null && !fullCategoryList.contains(category)) {
      category = null;
    }
    notifyListeners();
  }

  // Filtering getters (interface overrides)
  @override
  List<String> get categoryList =>
      products.map((p) => p.category).whereType<String>().toSet().toList();

  @override
  List<String> get brandsList =>
      products.map((p) => p.brand).whereType<String>().toSet().toList();

  @override
  bool get showCategoryFilter => categoryList.length > 1;

  @override
  bool get showBrandFilter => brandsList.length > 1;

  @override
  bool get showPriceFilter => products.isNotEmpty && maxPrice > minPrice;

  @override
  List<String> get availableStockStatuses {
    final statuses = ['All'];
    final counts = products.map((p) {
      final c = int.tryParse(p.itemCount ?? '0') ?? 0;
      final l = int.tryParse(p.lowStockCount ?? '0') ?? 0;
      if (c == 0) return 'Out of Stock';
      if (c <= l) return 'Low Stock';
      return 'In Stock';
    }).toSet();
    
    if (counts.contains('In Stock')) statuses.add('In Stock');
    if (counts.contains('Low Stock')) statuses.add('Low Stock');
    if (counts.contains('Out of Stock')) statuses.add('Out of Stock');
    
    return statuses;
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
    if (path == null) return;
    final cropped = await ImageCropUtil.cropImage(File(path));
    if (cropped == null) return;
    final savedPath = await ImageUtil.saveImage(cropped);
    if (index == null || index >= productImages.length) return;
    productImages[index] = File(savedPath);
    notifyListeners();
  }

  // Open gallery and save selected multiple images
  Future<void> openLibrary([int? index]) async {
    // Fetch multiple images from picker
    final paths = await ImageSelectorUtil.openLibraryMulti();
    if (paths == null || paths.isEmpty) return;
    
    int pathIndex = 0;
    // Iterate until we run out of selected images or fill the array
    while (pathIndex < paths.length && productImages.contains(null)) {
      // Find the left-most empty slot linearly
      final emptyIndex = productImages.indexOf(null);
      if (emptyIndex == -1) break; // Safety break if board is full
      
      // Request user to crop the image
      final cropped = await ImageCropUtil.cropImage(File(paths[pathIndex]));
      
      // If user cropped successfully, fill the slot
      if (cropped != null) {
        final savedPath = await ImageUtil.saveImage(cropped);
        productImages[emptyIndex] = File(savedPath);
      }
      
      // Always advance to the next selected image (handles both crop & cancel)
      pathIndex++;
    }
    notifyListeners();
  }

  // Remove selected image from form
  void removeImage(int index) {
    productImages.removeAt(index);
    productImages.add(null);
    notifyListeners();
  }

  // Returns true if at least one image exists
  bool get hasImage => productImages.any((img) => img != null);

  // Add new product to Hive database
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
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    dashboard.addNewActivity(activity);

    // Reload product list
    await loadProducts();
  }

  Future<void> loadProducts() async {
    products = await hiveService.getAllProducts();
    // Calculate maximum price for price filter slider
    final prices = products
        .map((p) => double.tryParse(p.salesRate ?? '0') ?? 0)
        .toList();
    if (prices.isNotEmpty) {
      final newMaxPrice = prices.reduce((a, b) => a > b ? a : b);
      final newMinPrice = prices.reduce((a, b) => a < b ? a : b);
      
      // If bounds changed, we might need to reset selections
      final boundsChanged = newMaxPrice != maxPrice || newMinPrice != minPrice;
      
      maxPrice = newMaxPrice;
      minPrice = newMinPrice;
      
      if (boundsChanged) {
        selectedMaxPrice = maxPrice;
        selectedMinPrice = minPrice;
        tempMaxPrice = maxPrice;
        tempMinPrice = minPrice;
      }
    } else {
      // Default reset if empty
      maxPrice = 0;
      minPrice = 0;
      selectedMaxPrice = 0;
      selectedMinPrice = 0;
      tempMaxPrice = 0;
      tempMinPrice = 0;
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
      final bool isAddition = newCount >= oldCount;
      final activity = DasboardActivity(
        image: newProduct.productImages.isNotEmpty
            ? newProduct.productImages[0]
            : AppImages.productImage1,
        title: 'Stock Updated',
        product: newProduct.productName,
        category: newProduct.category,
        unit: difference,
        label: isAddition ? 'units added' : 'units removed',
        isPositive: isAddition,
        date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
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
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    dashboard.addNewActivity(activity);
    await loadProducts();
  }

  // Validates form and saves new or updated product
  Future<bool> saveProductData(DashboardProvider dashboard) async {
    final form = secondFormKey.currentState;
    if (form == null || !form.validate()) return false;
    form.save();
    
    final newProduct = ProductModel(
      productImages: productImages
          .where((img) => img != null)
          .map((img) => img!.path)
          .toList(),
      productName: productName!,
      productDescription: productDescription!,
      brand: brand!,
      category: category!,
      purchaseRate: purchaseRate!,
      salesRate: salesRate!,
      itemCount: itemCount!,
      lowStockCount: lowStockCount!,
    );
    
    if (isEditing) {
      await updateProduct(editingIndex!, newProduct, dashboard);
    } else {
      await addProduct(newProduct, dashboard);
    }
    
    resetForm();
    clearEditing();
    return true;
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
  
  // Price boundaries found in products (used for price slider limits)
  @override
  double maxPrice = 100000;
  @override
  double minPrice = 0;
  
  // Currently applied price filter selection
  double selectedMaxPrice = 100000;
  double selectedMinPrice = 0;
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
  double tempMinPrice = 0;
  @override
  String tempStockStatus = 'All';
  // Returns true if any filter is currently active
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      selectedMinPrice > minPrice ||
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

  // Filter products based on selected price range
  List<ProductModel> _applyPriceFilter(List<ProductModel> list) {
    return list.where((n) {
      final price = double.tryParse(n.salesRate ?? '0') ?? 0;
      return price >= selectedMinPrice && price <= selectedMaxPrice;
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
    tempMinPrice = selectedMinPrice;
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

  // Update temporary price range from slider
  @override
  void setTempPriceRange(double min, double max) {
    tempMinPrice = min;
    tempMaxPrice = max;
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
    selectedMinPrice = tempMinPrice;
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
    selectedMinPrice = minPrice;
    stockStatus = 'All';
    tempCategories = {};
    tempBrands = {};
    tempMaxPrice = maxPrice;
    tempMinPrice = minPrice;
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
