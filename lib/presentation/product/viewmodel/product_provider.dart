import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/service/image_permission.dart';
import 'package:stock_pilot/core/service/image_selector.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProductProvider with ChangeNotifier {
  final ImagePermission imagePermission;
  final ImageSelector imageSelector;
  final HiveServiceLayer hiveService;

  ProductProvider({
    required this.imagePermission,
    required this.imageSelector,
    required this.hiveService,
  });

  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();
  List<File?> productImages = List.generate(4, (_) => null);
  String? productName;
  final productDescriptionFocus = FocusNode();
  String? productDescription;
  final itemCountFocus = FocusNode();
  String? itemCount;
  final lowStockCountFocus = FocusNode();
  String? lowStockCount;
  final List<String> brandsList = [
    'AudioTech Inc',
    'SoundPro',
    'MusicMaster',
    'BeatBox',
  ];
  String? brand;
  final List<String> categoryList = [
    'Wireless Hadphone',
    'Wireless Keyboard',
    'Wireless Mouse',
    'Bluetooth Speaker',
    'Wired Headphones',
    'Wired Keyboards',
  ];
  String? category;
  String? purchaseRate;
  final salesRateFocus = FocusNode();
  String? salesRate;
  List<ProductModel> products = [];

  Future<PermissionStatus> cameraPermission() async {
    return imagePermission.cameraPermission();
  }

  Future<PermissionStatus> libraryPermission() async {
    return imagePermission.libraryPermission();
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

  Future<void> addproduct(ProductModel product) async {
    await hiveService.addProduct(product);
  }

  Future<void> loadProducts() async {
    products = await hiveService.getAllProducts();
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

  Future<void> updateProduct(int index, ProductModel product) async {
    await hiveService.updateProduct(index, product);
    await loadProducts();
  }

  Future<void> deleteProduct(int index) async {
    await hiveService.deleteProduct(index);
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

  Color getStockColor(ProductModel product) {
    final count = int.tryParse(product.itemCount) ?? 0;
    final lowStock = int.tryParse(product.lowStockCount) ?? 0;
    if (count == 0) {
      return ColourStyles.colorRed;
    } else if (count <= lowStock) {
      return ColourStyles.colorYellow;
    } else {
      return ColourStyles.colorGreen;
    }
  }

  String getStockText(ProductModel product) {
    final count = int.tryParse(product.itemCount) ?? 0;
    if (count == 0) {
      return 'Out of Stock';
    } else {
      return '$count units';
    }
  }
}
