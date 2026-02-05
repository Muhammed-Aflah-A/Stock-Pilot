import 'package:flutter/material.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class BrandProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  BrandProvider({required this.hiveService}) {
    loadBrand();
  }
  List<BrandModel> brands = [];
  Future<void> addBrand(BrandModel brandName) async {
    await hiveService.addBrand(brandName);
    loadBrand();
  }

  Future<void> loadBrand() async {
    brands = await hiveService.getAllBrands();
    notifyListeners();
  }

  Future<void> updateBrand(int index, BrandModel brand) async {
    await hiveService.updateBrand(index, brand);
    await loadBrand();
  }

  Future<void> deleteBrand(int index) async {
    await hiveService.deleteBrand(index);
    await loadBrand();
  }
}
