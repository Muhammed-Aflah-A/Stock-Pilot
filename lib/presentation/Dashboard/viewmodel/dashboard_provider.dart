import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:hive_flutter/adapters.dart';

// Provider responsible for handling dashboard data and calculations
class DashboardProvider extends ChangeNotifier {
  // Hive service used to read data from local database
  final HiveServiceLayer hiveService;
  DashboardProvider({required this.hiveService}) {
    loadActivities();
    // Listen for changes in the sales box to update dashboard dynamically
    Hive.box<SalesItems>(HiveBoxes.sales)
        .listenable()
        .addListener(() => loadActivities());
  }
  // Stores all dashboard activities
  List<DasboardActivity> allActivities = [];
  // Stores summary cards shown on dashboard
  List<DashboardCards> dashboardCards = [];
  // Returns the latest 5 activities for dashboard display
  List<DasboardActivity> get recentActivities => allActivities.take(5).toList();
  // Returns the full activity history
  List<DasboardActivity> get fullHistory => allActivities;

  // Loads activities and dashboard data from Hive
  Future<void> loadActivities() async {
    // Fetch stored activities
    final activities = await hiveService.getAllActivities();
    // Fetch product list
    final products = await hiveService.getAllProducts();
    // Fetch brand list
    final brands = await hiveService.getAllBrands();
    // Fetch category list
    final categories = await hiveService.getAllCategories();
    // Fetch all sales for turnover calculation
    final sales = await hiveService.getAllSales();

    // Update activity list
    allActivities = activities;
    // Calculate turnover
    final turnover = _calculateMonthlyTurnover(sales);

    // Build dashboard summary cards
    dashboardCards = buildDashboardCards(
      products,
      brands.length,
      categories.length,
      turnover,
      sales,
    );
    // Notify UI to rebuild
    notifyListeners();
  }

  // Helper method to calculate monthly turnover from sales records
  double _calculateMonthlyTurnover(List<SalesItems> sales) {
    if (sales.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return sales.where((sale) {
      try {
        final saleDate = DateFormat('dd/MM/yyyy').parse(sale.date);
        return saleDate.month == currentMonth && saleDate.year == currentYear;
      } catch (e) {
        return false;
      }
    }).fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  // Builds all dashboard summary cards
  List<DashboardCards> buildDashboardCards(
    List<ProductModel> products,
    int brandCount,
    int categoryCount,
    double turnover,
    List<SalesItems> allSales,
  ) {
    // Calculate different dashboard values
    final totalItems = calculateTotalItems(products);
    final inventoryValue = calculateInventoryValue(products);
    final purchaseCost = calculatePurchaseCost(products, allSales);
    final lowStock = calculateLowStock(products);
    final outOfStock = calculateOutOfStock(products);
    // Create dashboard card models
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

  // Calculates total number of items across all products
  int calculateTotalItems(List<ProductModel> products) {
    int total = 0;
    for (var product in products) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      total += count;
    }
    return total;
  }

  // Calculates total inventory value based on sales rate
  double calculateInventoryValue(List<ProductModel> products) {
    double total = 0;
    for (var product in products) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final rate = double.tryParse(product.salesRate ?? '0') ?? 0;
      total += count * rate;
    }
    return total;
  }

  // Calculates total purchase cost of all active products (Stock + Sold)
  double calculatePurchaseCost(List<ProductModel> products, List<SalesItems> allSales) {
    // 1. Create a map of total units sold per product name
    final Map<String, int> soldCounts = {};
    for (var sale in allSales) {
      for (var item in sale.items) {
        final name = item.product.productName ?? "Unknown";
        soldCounts[name] = (soldCounts[name] ?? 0) + item.quantity;
      }
    }

    // 2. Sum (current stock + sold units) * purchase rate for each product
    double total = 0;
    for (var product in products) {
      final currentStock = int.tryParse(product.itemCount ?? '0') ?? 0;
      final soldUnits = soldCounts[product.productName] ?? 0;
      final rate = double.tryParse(product.purchaseRate ?? '0') ?? 0;
      
      total += (currentStock + soldUnits) * rate;
    }
    return total;
  }

  // Counts products that are in low stock
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

  // Counts products that are completely out of stock
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

  // Formats currency values for dashboard display
  String formatCurrency(double value) {
    if (value >= 1000) {
      return "\$${(value / 1000).toStringAsFixed(1)}k";
    }
    return "\$${value.toStringAsFixed(0)}";
  }

  // Adds a new activity to Hive and refreshes dashboard
  Future<void> addNewActivity(DasboardActivity activity) async {
    await hiveService.addActivity(activity);
    // Reload dashboard data after activity update
    await loadActivities();
  }
}
