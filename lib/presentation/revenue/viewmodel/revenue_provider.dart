import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:hive_flutter/adapters.dart';

enum TrendPeriod { day, week, month, sixMonths, year, custom }

class RevenueProvider extends ChangeNotifier {
  final HiveService hiveService;
  List<SalesItems> _sales = [];
  TrendPeriod _selectedPeriod = TrendPeriod.month;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  RevenueProvider({required this.hiveService}) {
    loadSales();
    // Listen for changes in the sales box to update revenue dynamically
    Hive.box<SalesItems>(
      HiveBoxes.sales,
    ).listenable().addListener(() => loadSales());
  }

  TrendPeriod get selectedPeriod => _selectedPeriod;
  DateTime? get customStartDate => _customStartDate;
  DateTime? get customEndDate => _customEndDate;

  bool get isCustomRangeMonthly {
    if (_selectedPeriod != TrendPeriod.custom ||
        _customStartDate == null ||
        _customEndDate == null) {
      return false;
    }
    final days = _customEndDate!.difference(_customStartDate!).inDays + 1;
    return days > 365;
  }

  void setPeriod(TrendPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCustomRange(DateTime start, DateTime end) {
    _customStartDate = start;
    _customEndDate = end;
    _selectedPeriod = TrendPeriod.custom;
    notifyListeners();
  }

  Future<void> loadSales() async {
    try {
      _sales = await hiveService.getAllSales();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading sales: $e");
    }
  }

  // --- Summary Metrics ---

  double get dailyRevenue => _calculateTotalForDate(DateTime.now());

  double get monthlyRevenue {
    final now = DateTime.now();
    return _calculateTotalForRange(DateTime(now.year, now.month, 1), now);
  }

  double get yearlyRevenue {
    final now = DateTime.now();
    return _calculateTotalForRange(DateTime(now.year, 1, 1), now);
  }

  // --- Trend Metrics ---

  double get totalForSelectedPeriod {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TrendPeriod.day:
        return dailyRevenue;
      case TrendPeriod.week:
        return _calculateTotalForRange(
          now.subtract(Duration(days: now.weekday - 1)),
          now,
        );
      case TrendPeriod.month:
        return monthlyRevenue;
      case TrendPeriod.sixMonths:
        return _calculateTotalForRange(
          DateTime(now.year, now.month - 5, 1),
          now,
        );
      case TrendPeriod.year:
        return yearlyRevenue;
      case TrendPeriod.custom:
        if (_customStartDate != null && _customEndDate != null) {
          return _calculateTotalForRange(_customStartDate!, _customEndDate!);
        }
        return 0;
    }
  }

  double get percentageChange {
    if (_selectedPeriod == TrendPeriod.custom) return 0; // Skip for custom
    final now = DateTime.now();
    double current = 0;
    double previous = 0;

    switch (_selectedPeriod) {
      case TrendPeriod.day:
        current = dailyRevenue;
        previous = _calculateTotalForDate(
          now.subtract(const Duration(days: 1)),
        );
        break;
      case TrendPeriod.week:
        current = totalForSelectedPeriod;
        previous = _calculateTotalForRange(
          now.subtract(Duration(days: now.weekday + 6)),
          now.subtract(Duration(days: now.weekday)),
        );
        break;
      case TrendPeriod.month:
        current = monthlyRevenue;
        previous = _calculateTotalForRange(
          DateTime(now.year, now.month - 1, 1),
          DateTime(now.year, now.month, 0),
        );
        break;
      case TrendPeriod.sixMonths:
        current = totalForSelectedPeriod;
        previous = _calculateTotalForRange(
          DateTime(now.year, now.month - 11, 1),
          DateTime(now.year, now.month - 5, 0),
        );
        break;
      case TrendPeriod.year:
        current = yearlyRevenue;
        previous = _calculateTotalForRange(
          DateTime(now.year - 1, 1, 1),
          DateTime(now.year - 1, 12, 31),
        );
        break;
      case TrendPeriod.custom:
        return 0;
    }

    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  }

  // --- Chart Data ---

  List<FlSpot> get chartSpots {
    final spots = <FlSpot>[];
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case TrendPeriod.day:
        // Showing last 2 days to show a trend line
        spots.add(
          FlSpot(
            0,
            _calculateTotalForDate(now.subtract(const Duration(days: 1))),
          ),
        );
        spots.add(FlSpot(1, dailyRevenue));
        break;
      case TrendPeriod.week:
        // Showing current calendar week (Monday to Sunday)
        final monday = now.subtract(Duration(days: now.weekday - 1));
        for (int i = 0; i < 7; i++) {
          final date = monday.add(Duration(days: i));
          spots.add(FlSpot(i.toDouble(), _calculateTotalForDate(date)));
        }
        break;
      case TrendPeriod.month:
        // Showing current calendar month (1st to Last Day)
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        for (int i = 0; i < lastDay; i++) {
          final date = DateTime(now.year, now.month, i + 1);
          spots.add(FlSpot(i.toDouble(), _calculateTotalForDate(date)));
        }
        break;
      case TrendPeriod.sixMonths:
        for (int i = 0; i < 6; i++) {
          final monthStart = DateTime(now.year, now.month - (5 - i), 1);
          final monthEnd = DateTime(now.year, now.month - (5 - i) + 1, 0);
          spots.add(
            FlSpot(i.toDouble(), _calculateTotalForRange(monthStart, monthEnd)),
          );
        }
        break;
      case TrendPeriod.year:
        for (int i = 0; i < 12; i++) {
          final monthStart = DateTime(now.year, i + 1, 1);
          final monthEnd = DateTime(now.year, i + 2, 0);
          spots.add(
            FlSpot(i.toDouble(), _calculateTotalForRange(monthStart, monthEnd)),
          );
        }
        break;
      case TrendPeriod.custom:
        if (_customStartDate != null && _customEndDate != null) {
          final days = _customEndDate!.difference(_customStartDate!).inDays + 1;
          if (days <= 365) {
            // Show daily spots for up to a year
            for (int i = 0; i < days; i++) {
              final date = _customStartDate!.add(Duration(days: i));
              spots.add(FlSpot(i.toDouble(), _calculateTotalForDate(date)));
            }
          } else {
            // Monthly grouping for ranges longer than a year
            final months = ((_customEndDate!.year - _customStartDate!.year) * 12) +
                _customEndDate!.month -
                _customStartDate!.month +
                1;
            for (int i = 0; i < months; i++) {
              final monthStart =
                  DateTime(_customStartDate!.year, _customStartDate!.month + i, 1);
              final monthEnd =
                  DateTime(_customStartDate!.year, _customStartDate!.month + i + 1, 0);
              spots.add(
                FlSpot(i.toDouble(), _calculateTotalForRange(monthStart, monthEnd)),
              );
            }
          }
        }
        break;
    }
    return spots;
  }

  // --- Most Sold Items (All-Time) ---

  List<MapEntry<ProductModel, int>> get mostSoldItems {
    final Map<String, int> productCounts = {};
    final Map<String, ProductModel> productMap = {};

    for (var sale in _sales) {
      for (var item in sale.items) {
        final productName = item.product.productName ?? "Unknown";
        productCounts[productName] =
            (productCounts[productName] ?? 0) + item.quantity;
        productMap[productName] = item.product;
      }
    }

    final sortedEntries = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(5)
        .map((e) => MapEntry(productMap[e.key]!, e.value))
        .toList();
  }

  // --- Helper Methods ---

  double _calculateTotalForDate(DateTime date) {
    final dateStrNew = DateFormat('dd - MMM - yyyy', 'en_US').format(date);
    final dateStrOld = DateFormat('dd/MM/yyyy', 'en_US').format(date);
    return _sales
        .where((sale) => sale.date == dateStrNew || sale.date == dateStrOld)
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  double _calculateTotalForRange(DateTime start, DateTime end) {
    return _sales
        .where((sale) {
          final saleDate = _parseDate(sale.date);
          return saleDate != null &&
              saleDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
              saleDate.isBefore(end.add(const Duration(seconds: 1)));
        })
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  DateTime? _parseDate(String dateStr) {
    try {
      if (dateStr.contains('/')) {
        return DateFormat('dd/MM/yyyy', 'en_US').parse(dateStr);
      } else {
        return DateFormat('dd - MMM - yyyy', 'en_US').parse(dateStr);
      }
    } catch (e) {
      return null;
    }
  }
}
