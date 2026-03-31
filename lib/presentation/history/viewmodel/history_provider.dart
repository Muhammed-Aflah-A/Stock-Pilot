import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';

enum HistorySortOption {
  latest,
  oldest,
}

class HistoryProvider extends FilterProviderInterface {
  final HiveService hiveService;

  HistoryProvider({required this.hiveService}) {
    loadData();
  }

  List<SalesItems> sales = [];
  List<DasboardActivity> allActivities = [];
  List<DasboardActivity> filteredActivities = [];
  String searchQuery = "";
  HistorySortOption currentSort = HistorySortOption.latest;

  // Filter state
  String appliedStockStatus = 'All';
  @override
  String tempStockStatus = 'All';

  Future<void> loadData() async {
    try {
      sales = await hiveService.getAllSales();
      allActivities = await hiveService.getAllActivities();
      _applyFilters();
    } catch (e) {
      debugPrint("Error loading history data: $e");
    }
    notifyListeners();
  }

  Future<void> addSale(SalesItems sale) async {
    await hiveService.addSale(sale);
    await loadData();
  }

  Future<void> loadSales() async {
    sales = await hiveService.getAllSales();
    notifyListeners();
  }

  SalesItems? get latestSale {
    if (sales.isEmpty) return null;
    return sales.first;
  }

  // Search & Filter Logic

  void searchHistory(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<DasboardActivity> result = List.from(allActivities);

    // Filter by search query (Product name or Date)
    if (searchQuery.isNotEmpty) {
      result = result.where((activity) {
        final productName = (activity.product ?? '').toLowerCase();
        final date = (activity.date ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();
        return productName.contains(query) || date.contains(query);
      }).toList();
    }

    // Filter by Activity Type (mapped as Added, Updated, Deleted, Sold)
    if (appliedStockStatus != 'All') {
      result = result.where((activity) {
        final title = activity.title ?? '';
        switch (appliedStockStatus) {
          case 'Added':
            return title == 'Stock Added';
          case 'Updated':
            return title == 'Stock Updated';
          case 'Deleted':
            return title == 'Stock Deleted';
          case 'Sold':
            return title == 'Item Sold';
          default:
            return true;
        }
      }).toList();
    }

    // Apply Sorting
    result.sort((a, b) {
      DateTime? dateA = _tryParseDate(a.date);
      DateTime? dateB = _tryParseDate(b.date);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      if (currentSort == HistorySortOption.latest) {
        return dateB.compareTo(dateA);
      } else {
        return dateA.compareTo(dateB);
      }
    });

    filteredActivities = result;
  }

  DateTime? _tryParseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  void sortHistory(HistorySortOption option) {
    currentSort = option;
    _applyFilters();
    notifyListeners();
  }

  // FilterProviderInterface Implementation

  @override
  bool get hasActiveFilters => appliedStockStatus != 'All';

  @override
  List<String> get availableStockStatuses {
    final statuses = ['All'];
    final titles = allActivities.map((a) => a.title).toSet();

    if (titles.contains('Stock Added')) statuses.add('Added');
    if (titles.contains('Stock Updated')) statuses.add('Updated');
    if (titles.contains('Stock Deleted')) statuses.add('Deleted');
    if (titles.contains('Item Sold')) statuses.add('Sold');

    return statuses;
  }

  @override
  void applyFilters() {
    appliedStockStatus = tempStockStatus;
    _applyFilters();
    notifyListeners();
  }

  @override
  void clearFilters() {
    appliedStockStatus = 'All';
    tempStockStatus = 'All';
    _applyFilters();
    notifyListeners();
  }

  @override
  void initTempFilters() {
    tempStockStatus = appliedStockStatus;
    notifyListeners();
  }

  @override
  void setTempStockStatus(String status) {
    tempStockStatus = status;
    notifyListeners();
  }

  // Not used in History but required by interface
  @override
  double get maxPrice => 0;
  @override
  double get minPrice => 0;
  @override
  double get tempMaxPrice => 0;
  @override
  double get tempMinPrice => 0;
  @override
  Set<String> get tempCategories => {};
  @override
  Set<String> get tempBrands => {};
  @override
  List<String> get categoryList => [];
  @override
  List<String> get brandsList => [];
  @override
  bool get showPriceFilter => false;
  @override
  bool get showCategoryFilter => false;
  @override
  bool get showBrandFilter => false;

  @override
  void setTempPriceRange(double min, double max) {}
  @override
  void toggleTempBrand(String brand) {}
  @override
  void toggleTempCategory(String cat) {}
}
