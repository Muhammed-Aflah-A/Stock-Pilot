import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:hive_flutter/adapters.dart';

class RevenueProvider extends ChangeNotifier {
  final HiveService hiveService;
  List<SalesItems> _sales = [];

  RevenueProvider({required this.hiveService}) {
    loadSales();
    // Listen for changes in the sales box to update revenue dynamically
    Hive.box<SalesItems>(HiveBoxes.sales)
        .listenable()
        .addListener(() => loadSales());
  }

  Future<void> loadSales() async {
    try {
      _sales = await hiveService.getAllSales();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading sales: $e");
    }
  }

  double get dailyRevenue {
    final now = DateTime.now();
    final todayStr = DateFormat('dd/MM/yyyy').format(now);
    
    return _sales
        .where((sale) => sale.date == todayStr)
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  double get monthlyRevenue {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return _sales.where((sale) {
      final saleDate = _parseDate(sale.date);
      return saleDate != null && 
             saleDate.month == currentMonth && 
             saleDate.year == currentYear;
    }).fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  double get yearlyRevenue {
    final now = DateTime.now();
    final currentYear = now.year;

    return _sales.where((sale) {
      final saleDate = _parseDate(sale.date);
      return saleDate != null && saleDate.year == currentYear;
    }).fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}
