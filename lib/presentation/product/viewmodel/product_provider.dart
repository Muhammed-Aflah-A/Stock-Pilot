import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';

class ProductProvider with ChangeNotifier {
  final ImageSelectorUtil imageSelector;
  final HiveServiceLayer hiveService;

  ProductProvider({required this.imageSelector, required this.hiveService}) {
    loadProducts();
  }

  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();
  List<File?> productImages = List.generate(4, (_) => null);
  String? productName;
  final productDescriptionFocus = FocusNode();
  String? productDescription;
  List<String> brandsList = [];
  void brands(List<BrandModel> newBrands) {
    brandsList = newBrands.map((e) => e.brand ?? 'Unknown').toList();
    if (brand != null && !brandsList.contains(brand)) {
      brand = null;
    }
    notifyListeners();
  }

  String? brand;
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

  List<ProductModel> get lowStockProducts {
    return products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();
  }

  List<ProductModel> get outOfStockProducts {
    return products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      return count == 0;
    }).toList();
  }
}
