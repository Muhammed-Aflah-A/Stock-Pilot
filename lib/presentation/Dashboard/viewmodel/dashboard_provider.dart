import 'package:flutter/material.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class DashboardProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;

  DashboardProvider({required this.hiveService}) {
    initDashboard();
  }

  List<DashboardCards> _dashboardCards = [];
  List<DashboardCards> get dashboardCards => _dashboardCards;
  List<DasboardActivity> _allActivities = [];
  List<DasboardActivity> get recentActivities =>
      _allActivities.take(5).toList();
  List<DasboardActivity> get fullHistory => _allActivities;
  final double _monthlyTurnover = 0.0;
  Future<void> initDashboard() async {
    await loadActivities();
  }

  Future<void> loadActivities() async {
    final results = await Future.wait([
      hiveService.getAllActivities(),
      hiveService.getAllProducts(),
      hiveService.getAllCategories(),
      hiveService.getAllBrands(),
    ]);

    _allActivities = results[0] as List<DasboardActivity>;
    final products = results[1] as List<ProductModel>;
    final totalBrands = (results[3] as List).length;
    final totalCategory = (results[2] as List).length;
    updateValues(products, totalBrands, totalCategory);
    notifyListeners();
  }

  void updateValues(
    List<ProductModel> products,
    int globalBrandCount,
    int globalCategoryCount,
  ) {
    int totalItems = 0;
    double totalInventoryValue = 0.0;
    double totalPurchaseCost = 0.0;
    Set<String> categories = {};
    Set<String> brands = {};
    int lowStockCount = 0;
    int outOfStockCount = 0;
    for (var product in products) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowLimit = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      final sRate = double.tryParse(product.salesRate ?? '0') ?? 0.0;
      final pRate = double.tryParse(product.purchaseRate ?? '0') ?? 0.0;
      totalItems += count;
      totalInventoryValue += (count * sRate);
      totalPurchaseCost += (count * pRate);
      if (product.category != null && product.category!.trim().isNotEmpty) {
        categories.add(product.category!.trim().toLowerCase());
      }
      if (product.brand != null && product.brand!.trim().isNotEmpty) {
        brands.add(product.brand!.trim().toLowerCase());
      }
      if (count == 0) {
        outOfStockCount++;
      } else if (count <= lowLimit) {
        lowStockCount++;
      }
    }
    _dashboardCards = [
      DashboardCards(title: "Total Items", value: totalItems.toString()),
      DashboardCards(
        title: "Total Value",
        value: formatCurrency(totalInventoryValue),
      ),
      DashboardCards(title: "Total Brand", value: globalBrandCount.toString()),
      DashboardCards(
        title: "Total Category",
        value: globalCategoryCount.toString(),
      ),
      DashboardCards(
        title: "Purchase Cost",
        value: formatCurrency(totalPurchaseCost),
      ),
      DashboardCards(
        title: "Monthly Turnover",
        value: formatCurrency(_monthlyTurnover),
      ),
      DashboardCards(title: "Low Stock", value: lowStockCount.toString()),
      DashboardCards(title: "Out of Stock", value: outOfStockCount.toString()),
    ];
  }

  String formatCurrency(double value) {
    if (value >= 1000) return "\$${(value / 1000).toStringAsFixed(1)}k";
    return "\$${value.toStringAsFixed(0)}";
  }

  Future<void> addNewActivity(DasboardActivity activity) async {
    await hiveService.addActivity(activity);
    await loadActivities();
  }
}
