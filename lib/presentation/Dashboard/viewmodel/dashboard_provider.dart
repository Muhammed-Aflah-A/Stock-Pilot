import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/date_util.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';

class DashboardProvider extends ChangeNotifier {
  final HiveServiceLayer hiveService;
  DashboardProvider({required this.hiveService}) {
    loadActivities();
    Hive.box<SalesItems>(
      HiveBoxes.sales,
    ).listenable().addListener(() => loadActivities());
  }
  List<DasboardActivity> allActivities = [];
  List<DashboardCards> dashboardCards = [];
  List<DasboardActivity> get recentActivities => allActivities.take(5).toList();
  List<DasboardActivity> get fullHistory => allActivities;

  Future<void> loadActivities() async {
    final activities = await hiveService.getAllActivities();
    final products = await hiveService.getAllProducts();
    final brands = await hiveService.getAllBrands();
    final categories = await hiveService.getAllCategories();
    final sales = await hiveService.getAllSales();

    allActivities = activities;
    final turnover = _calculateMonthlyTurnover(sales);

    dashboardCards = buildDashboardCards(
      products,
      brands.length,
      categories.length,
      turnover,
      sales,
    );
    notifyListeners();
  }

  double _calculateMonthlyTurnover(List<SalesItems> sales) {
    if (sales.isEmpty) return 0.0;

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return sales
        .where((sale) {
          final saleDate = DateUtil.parse(sale.date);
          if (saleDate == null) return false;
          return saleDate.month == currentMonth && saleDate.year == currentYear;
        })
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  List<DashboardCards> buildDashboardCards(
    List<ProductModel> products,
    int brandCount,
    int categoryCount,
    double turnover,
    List<SalesItems> allSales,
  ) {
    final totalItems = calculateTotalItems(products);
    final inventoryValue = calculateInventoryValue(products);
    final purchaseCost = calculatePurchaseCost(products, allSales);
    final lowStock = calculateLowStock(products);
    final outOfStock = calculateOutOfStock(products);
    return [
      DashboardCards(title: "Total Items", value: totalItems.toString()),
      DashboardCards(
        title: "Total Value",
        value: formatCurrency(inventoryValue),
      ),
      DashboardCards(title: "Total Brand", value: brandCount.toString()),
      DashboardCards(title: "Total Category", value: categoryCount.toString()),
      DashboardCards(
        title: "Purchase Cost",
        value: formatCurrency(purchaseCost),
      ),
      DashboardCards(
        title: "Monthly Turnover",
        value: formatCurrency(turnover),
      ),
      DashboardCards(title: "Low Stock", value: lowStock.toString()),
      DashboardCards(title: "Out of Stock", value: outOfStock.toString()),
    ];
  }

  int calculateTotalItems(List<ProductModel> products) {
    int total = 0;
    for (var product in products) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      total += count;
    }
    return total;
  }

  double calculateInventoryValue(List<ProductModel> products) {
    double total = 0;
    for (var product in products) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final rate = double.tryParse(product.salesRate ?? '0') ?? 0;
      total += count * rate;
    }
    return total;
  }

  double calculatePurchaseCost(
    List<ProductModel> products,
    List<SalesItems> allSales,
  ) {
    final Map<String, int> soldCounts = {};
    for (var sale in allSales) {
      for (var item in sale.items) {
        final name = item.product.productName ?? "Unknown";
        soldCounts[name] = (soldCounts[name] ?? 0) + item.quantity;
      }
    }

    double total = 0;
    for (var product in products) {
      final currentStock = int.tryParse(product.itemCount ?? '0') ?? 0;
      final soldUnits = soldCounts[product.productName] ?? 0;
      final rate = double.tryParse(product.purchaseRate ?? '0') ?? 0;

      total += (currentStock + soldUnits) * rate;
    }
    return total;
  }

  int calculateLowStock(List<ProductModel> products) {
    int count = 0;
    for (var product in products) {
      final stock = int.tryParse(product.itemCount ?? '0') ?? 0;
      final limit = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      if (stock > 0 && stock <= limit) {
        count++;
      }
    }
    return count;
  }

  int calculateOutOfStock(List<ProductModel> products) {
    int count = 0;
    for (var product in products) {
      final stock = int.tryParse(product.itemCount ?? '0') ?? 0;
      if (stock == 0) {
        count++;
      }
    }
    return count;
  }

  String formatCurrency(double value) {
    return NumberFormatterUtil.formatCurrency(value);
  }

  Future<void> addNewActivity(DasboardActivity activity) async {
    await hiveService.addActivity(activity);
    await loadActivities();
  }
}
