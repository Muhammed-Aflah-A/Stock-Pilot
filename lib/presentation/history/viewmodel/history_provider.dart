import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stock_pilot/core/utils/date_util.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';

enum HistorySortOption { latest, oldest }

enum HistoryTab { purchase, updates, sales }

class HistoryProvider extends FilterProviderInterface {
  final HiveService hiveService;

  HistoryProvider({required this.hiveService}) {
    loadData();
    Hive.box<DasboardActivity>(
      HiveBoxes.dashBoardActivity,
    ).listenable().addListener(() => loadData());
  }

  List<SalesItems> sales = [];
  List<DasboardActivity> allActivities = [];
  List<DasboardActivity> filteredActivities = [];
  String searchQuery = "";
  HistorySortOption currentSort = HistorySortOption.latest;
  HistoryTab currentTab = HistoryTab.purchase;

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

  void searchHistory(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setTab(HistoryTab tab) {
    currentTab = tab;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<DasboardActivity> result = List.from(allActivities);

    result = result.where((activity) {
      final title = activity.title ?? '';
      switch (currentTab) {
        case HistoryTab.purchase:
          return title == 'Stock Added';
        case HistoryTab.updates:
          return title == 'Stock Updated' || title == 'Stock Deleted';
        case HistoryTab.sales:
          return title == 'Item Sold';
      }
    }).toList();

    if (searchQuery.isNotEmpty) {
      result = result.where((activity) {
        final productName = (activity.product ?? '').toLowerCase();
        final date = (activity.date ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();
        return productName.contains(query) || date.contains(query);
      }).toList();
    }

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
    return DateUtil.parse(date);
  }

  void sortHistory(HistorySortOption option) {
    currentSort = option;
    _applyFilters();
    notifyListeners();
  }

  @override
  bool get hasActiveFilters => false;

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
    _applyFilters();
    notifyListeners();
  }

  @override
  void clearFilters() {
    searchQuery = "";
    tempStockStatus = 'All';
    _applyFilters();
    notifyListeners();
  }

  @override
  void initTempFilters() {
    notifyListeners();
  }

  @override
  void setTempStockStatus(String status) {
    tempStockStatus = status;
    notifyListeners();
  }

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
