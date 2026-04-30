import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

enum LowStockSortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class LowstockProvider extends FilterProviderInterface {
  late ProductProvider _productProvider;
  bool _isProviderSet = false;
  List<ProductModel> filteredLowStock = [];
  String _searchQuery = "";
  LowStockSortOption _currentSort = LowStockSortOption.priceLowToHigh;
  LowStockSortOption get currentSort => _currentSort;
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};
  @override
  double maxPrice = 10000;
  @override
  double minPrice = 0;

  double selectedMaxPrice = 10000;
  double selectedMinPrice = 0;

  String stockStatus = 'All';
  @override
  Set<String> tempCategories = {};
  @override
  Set<String> tempBrands = {};
  @override
  double tempMaxPrice = 10000;
  @override
  double tempMinPrice = 0;
  @override
  String tempStockStatus = 'All';
  @override
  bool get showStockFilter => false;
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      selectedMinPrice > minPrice;
  @override
  List<String> categoryList = [];
  @override
  List<String> brandsList = [];

  @override
  bool get showCategoryFilter => categoryList.length > 1;

  @override
  bool get showBrandFilter => brandsList.length > 1;

  @override
  bool get showPriceFilter =>
      _isProviderSet && categoryList.isNotEmpty && maxPrice > minPrice;

  @override
  List<String> get availableStockStatuses => ['Low Stock'];
  @override
  void initTempFilters() {
    tempCategories = {...selectedCategories};
    tempBrands = {...selectedBrands};
    tempMaxPrice = selectedMaxPrice;
    tempMinPrice = selectedMinPrice;
    tempStockStatus = stockStatus;
    notifyListeners();
  }

  @override
  void toggleTempCategory(String cat) {
    tempCategories.contains(cat)
        ? tempCategories.remove(cat)
        : tempCategories.add(cat);
    notifyListeners();
  }

  @override
  void toggleTempBrand(String brand) {
    tempBrands.contains(brand)
        ? tempBrands.remove(brand)
        : tempBrands.add(brand);
    notifyListeners();
  }

  @override
  void setTempPriceRange(double min, double max) {
    tempMinPrice = min;
    tempMaxPrice = max;
    notifyListeners();
  }

  @override
  void setTempStockStatus(String status) {
    tempStockStatus = status;
    notifyListeners();
  }

  @override
  void applyFilters() {
    selectedCategories = {...tempCategories};
    selectedBrands = {...tempBrands};
    selectedMaxPrice = tempMaxPrice;
    selectedMinPrice = tempMinPrice;
    stockStatus = tempStockStatus;
    _applyLowStockSearch();
  }

  @override
  void clearFilters() {
    selectedCategories.clear();
    selectedBrands.clear();
    selectedMaxPrice = maxPrice;
    selectedMinPrice = minPrice;
    stockStatus = 'All';
    tempCategories.clear();
    tempBrands.clear();
    tempMaxPrice = maxPrice;
    tempMinPrice = minPrice;
    tempStockStatus = 'All';
    _applyLowStockSearch();
  }

  void updateProductProvider(ProductProvider provider) {
    if (_isProviderSet) {
      _productProvider.removeListener(_onProductProviderChanged);
    }
    _productProvider = provider;
    _isProviderSet = true;
    _productProvider.addListener(_onProductProviderChanged);
    _updateFilterBounds();
    _applyLowStockSearch();
  }

  void _updateFilterBounds() {
    if (!_isProviderSet) return;

    final baseList = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();

    categoryList = baseList
        .map((p) => p.category)
        .whereType<String>()
        .toSet()
        .toList();
    brandsList = baseList
        .map((p) => p.brand)
        .whereType<String>()
        .toSet()
        .toList();

    final prices = baseList
        .map((p) => double.tryParse(p.salesRate ?? '0') ?? 0)
        .toList();

    if (prices.isNotEmpty) {
      final newMax = prices.reduce((a, b) => a > b ? a : b);
      final newMin = prices.reduce((a, b) => a < b ? a : b);

      final boundsChanged = newMax != maxPrice || newMin != minPrice;

      maxPrice = newMax;
      minPrice = newMin;

      if (boundsChanged) {
        selectedMaxPrice = maxPrice;
        selectedMinPrice = minPrice;
        tempMaxPrice = maxPrice;
        tempMinPrice = minPrice;
      }
    } else {
      maxPrice = 0;
      minPrice = 0;
      selectedMaxPrice = 0;
      selectedMinPrice = 0;
      tempMaxPrice = 0;
      tempMinPrice = 0;
    }
    notifyListeners();
  }

  void _onProductProviderChanged() {
    _updateFilterBounds();
    _applyLowStockSearch();
  }

  @override
  void dispose() {
    if (_isProviderSet) {
      _productProvider.removeListener(_onProductProviderChanged);
    }
    super.dispose();
  }

  void searchLowStock(String query) {
    _searchQuery = query;
    _applyLowStockSearch();
  }

  void clearSearch() {
    _searchQuery = "";
    _applyLowStockSearch();
  }

  void sortProducts(LowStockSortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  void _applyLowStockSearch() {
    if (!_isProviderSet) return;
    List<ProductModel> result = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();
    result = SearchBarUtil.getFilteredList<ProductModel>(
      sourceList: result,
      query: _searchQuery,
      searchField: (p) => p.productName ?? "",
    );
    if (selectedCategories.isNotEmpty) {
      result = result
          .where((p) => selectedCategories.contains(p.category))
          .toList();
    }
    if (selectedBrands.isNotEmpty) {
      result = result.where((p) => selectedBrands.contains(p.brand)).toList();
    }
    result = result.where((p) {
      final price = double.tryParse(p.salesRate ?? '0') ?? 0;
      return price >= selectedMinPrice && price <= selectedMaxPrice;
    }).toList();
    filteredLowStock = result;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    filteredLowStock.sort((a, b) {
      final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
      final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
      switch (_currentSort) {
        case LowStockSortOption.priceLowToHigh:
          return aPrice.compareTo(bPrice);
        case LowStockSortOption.priceHighToLow:
          return bPrice.compareTo(aPrice);
        case LowStockSortOption.alphabeticalAZ:
          return (a.productName ?? '').toLowerCase().compareTo(
            (b.productName ?? '').toLowerCase(),
          );
        case LowStockSortOption.alphabeticalZA:
          return (b.productName ?? '').toLowerCase().compareTo(
            (a.productName ?? '').toLowerCase(),
          );
      }
    });
  }
}
