import 'package:flutter/material.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/cart_model.dart';

class HistoryProvider with ChangeNotifier {
  final HiveService hiveService;

  HistoryProvider({required this.hiveService}) {
    loadSales();
  }

  List<SalesItems> sales = [];

  Future<void> addSale(SalesItems sale) async {
    await hiveService.addSale(sale);
    sales.insert(0, sale);
    notifyListeners();
  }

  Future<void> loadSales() async {
    sales = await hiveService.getAllSales();
    notifyListeners();
  }

  SalesItems? get latestSale {
    if (sales.isEmpty) return null;
    return sales.first;
  }
}
