import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/utils/crop_image_util.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/date_util.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/notification/viewmodel/notification_provider.dart';
import 'package:stock_pilot/data/models/notification_model.dart';

enum SortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class ProductProvider extends FilterProviderInterface
    implements ImagePermissionHandler {
  final HiveServiceLayer hiveService;
  NotificationProvider? notificationProvider;
  ProductProvider({required this.hiveService}) {
    loadProducts();
  }

  void updateNotificationProvider(NotificationProvider provider) {
    notificationProvider = provider;
  }

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  String searchQuery = "";
  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();
  String? productName;
  String? productDescription;
  String? brand;
  String? category;
  String? purchaseRate;
  String? salesRate;
  String? itemCount;
  String? lowStockCount;
  final productDescriptionFocus = FocusNode();
  final salesRateFocus = FocusNode();
  final itemCountFocus = FocusNode();
  final lowStockCountFocus = FocusNode();
  List<String?> productImages = List.generate(4, (_) => null);
  ProductModel? editingProduct;
  int? editingIndex;
  int? activeProductIndex;

  void setActiveProductIndex(int index) {
    activeProductIndex = index;
    notifyListeners();
  }

  bool get isEditing => editingProduct != null;
  List<String> fullBrandsList = [];
  void setBrands(List<BrandModel> newBrands) {
    fullBrandsList = newBrands.map((n) => n.brand ?? 'Unknown').toList();
    if (brand != null && !fullBrandsList.contains(brand)) {
      brand = null;
    }
    notifyListeners();
  }

  List<String> fullCategoryList = [];
  void setCategories(List<CategoryModel> newCategories) {
    fullCategoryList = newCategories
        .map((n) => n.category ?? 'Unknown')
        .toList();
    if (category != null && !fullCategoryList.contains(category)) {
      category = null;
    }
    notifyListeners();
  }

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

  void searchProducts(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = "";
    _applyFilters();
    notifyListeners();
  }

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

  Future<void> openCamera(BuildContext context, [int? index]) async {
    final path = await ImageSelectorUtil.openCamera();
    if (path == null) return;
    if (!context.mounted) return;
    final croppedPath = await ImageCropUtil.cropImageToPath(
      path,
      context: context,
    );
    if (croppedPath == null) return;
    final savedPath = await ImageUtil.saveImage(croppedPath);
    if (index == null || index >= productImages.length) return;
    final newImages = List<String?>.from(productImages);
    newImages[index] = savedPath;
    productImages = newImages;
    notifyListeners();
  }

  Future<void> openLibrary(BuildContext context, [int? index]) async {
    final paths = await ImageSelectorUtil.openLibraryMulti();
    if (paths == null || paths.isEmpty) return;

    int pathIndex = 0;
    final newImages = List<String?>.from(productImages);
    while (pathIndex < paths.length && newImages.contains(null)) {
      final emptyIndex = newImages.indexOf(null);
      if (emptyIndex == -1) break;

      if (!context.mounted) break;
      final croppedPath = await ImageCropUtil.cropImageToPath(
        paths[pathIndex],
        context: context,
      );

      if (croppedPath != null) {
        final savedPath = await ImageUtil.saveImage(croppedPath);
        newImages[emptyIndex] = savedPath;
      }

      pathIndex++;
    }
    productImages = newImages;
    notifyListeners();
  }

  @override
  void removeImage({int? index}) {
    if (index == null || index >= productImages.length) return;
    final newImages = List<String?>.from(productImages);
    newImages.removeAt(index);
    newImages.add(null);
    productImages = newImages;
    notifyListeners();
  }

  bool get hasImage => productImages.any((img) => img != null);

  Future<void> addProduct(
    ProductModel product,
    DashboardProvider dashboard,
  ) async {
    await hiveService.addProduct(product);
    final activity = DasboardActivity(
      image: product.productImages.isNotEmpty ? product.productImages[0] : null,
      title: 'Stock Added',
      product: product.productName,
      category: product.category,
      unit: int.tryParse(product.itemCount ?? '0') ?? 0,
      label: 'units added',
      isPositive: true,
      date: DateUtil.now(),
      brand: product.brand,
    );
    dashboard.addNewActivity(activity);
    await loadProducts();
    notificationProvider?.addNotification(
      title: product.productName ?? 'Unknown Product',
      subtitle: 'Product Added',
      type: NotificationType.add,
    );
    _checkStockAndNotify(product);
  }

  Future<void> loadProducts() async {
    products = await hiveService.getAllProducts();
    final prices = products
        .map((p) => double.tryParse(p.salesRate ?? '0') ?? 0)
        .toList();
    if (prices.isNotEmpty) {
      final newMaxPrice = prices.reduce((a, b) => a > b ? a : b);
      final newMinPrice = prices.reduce((a, b) => a < b ? a : b);

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
        date: DateUtil.now(),
        brand: newProduct.brand,
      );
      dashboard.addNewActivity(activity);
    }
    await loadProducts();
    notificationProvider?.addNotification(
      title: newProduct.productName ?? 'Unknown Product',
      subtitle: 'Stock Updated',
      type: NotificationType.update,
    );
    _checkStockAndNotify(newProduct);
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
      date: DateUtil.now(),
      brand: product.brand,
    );
    dashboard.addNewActivity(activity);
    await loadProducts();
    notificationProvider?.addNotification(
      title: product.productName ?? 'Unknown Product',
      subtitle: 'Stock Deleted',
      type: NotificationType.delete,
    );
  }

  void _checkStockAndNotify(ProductModel product) {
    final count = int.tryParse(product.itemCount ?? '0') ?? 0;
    final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;

    if (count == 0) {
      notificationProvider?.addNotification(
        title: product.productName ?? 'Unknown Product',
        subtitle: 'Out of Stock',
        type: NotificationType.outOfStock,
      );
    } else if (count <= lowStock) {
      notificationProvider?.addNotification(
        title: product.productName ?? 'Unknown Product',
        subtitle:
            'Low Stock: ${NumberFormatterUtil.format(count)} units remaining',
        type: NotificationType.lowStock,
      );
    }
  }

  Future<bool> saveProductData(DashboardProvider dashboard) async {
    final form = secondFormKey.currentState;
    if (form == null || !form.validate()) return false;
    form.save();

    final newProduct = ProductModel(
      productImages: productImages
          .where((img) => img != null)
          .map((img) => img!)
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

  SortOption currentSort = SortOption.priceLowToHigh;

  void sortProducts(SortOption option) {
    currentSort = option;
    _applySorting();
    notifyListeners();
  }

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

  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};

  @override
  double maxPrice = 100000;
  @override
  double minPrice = 0;

  double selectedMaxPrice = 100000;
  double selectedMinPrice = 0;
  String stockStatus = 'All';
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
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      selectedMinPrice > minPrice ||
      stockStatus != 'All';
  void _applyFilters() {
    List<ProductModel> result = List.from(products);
    result = _applySearch(result);
    result = _applyCategoryFilter(result);
    result = _applyBrandFilter(result);
    result = _applyPriceFilter(result);
    result = _applyStockFilter(result);
    filteredProducts = result;
    _applySorting();
  }

  List<ProductModel> _applySearch(List<ProductModel> list) {
    if (searchQuery.isEmpty) return list;
    return list.where((n) {
      return (n.productName ?? '').toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
    }).toList();
  }

  List<ProductModel> _applyCategoryFilter(List<ProductModel> list) {
    if (selectedCategories.isEmpty) return list;
    return list.where((n) {
      return selectedCategories.contains(n.category);
    }).toList();
  }

  List<ProductModel> _applyBrandFilter(List<ProductModel> list) {
    if (selectedBrands.isEmpty) return list;
    return list.where((n) {
      return selectedBrands.contains(n.brand);
    }).toList();
  }

  List<ProductModel> _applyPriceFilter(List<ProductModel> list) {
    return list.where((n) {
      final price = double.tryParse(n.salesRate ?? '0') ?? 0;
      return price >= selectedMinPrice && price <= selectedMaxPrice;
    }).toList();
  }

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

  @override
  void initTempFilters() {
    tempCategories = Set.from(selectedCategories);
    tempBrands = Set.from(selectedBrands);
    tempMaxPrice = selectedMaxPrice;
    tempMinPrice = selectedMinPrice;
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
  void setTempPriceRange(double min, double max) {
    tempMinPrice = min;
    tempMaxPrice = max;
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
    selectedMinPrice = tempMinPrice;
    stockStatus = tempStockStatus;
    _applyFilters();
    notifyListeners();
  }

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

  void setEditingProduct(ProductModel product, int index) {
    productImages = List.generate(4, (_) => null);
    for (int i = 0; i < product.productImages.length && i < 4; i++) {
      productImages[i] = product.productImages[i];
    }
    editingProduct = product;
    editingIndex = index;
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

  void clearEditing() {
    editingProduct = null;
    editingIndex = null;
    notifyListeners();
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
    clearEditing();
    notifyListeners();
  }

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

  String getStockText(ProductModel product) {
    final count = int.tryParse(product.itemCount ?? '0') ?? 0;
    final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
    if (count == 0) {
      return 'Out of stock : ${NumberFormatterUtil.format(count)}';
    } else if (count <= lowStock) {
      return 'Low stock : ${NumberFormatterUtil.format(count)}';
    } else {
      return 'In stock : ${NumberFormatterUtil.format(count)}';
    }
  }
}
