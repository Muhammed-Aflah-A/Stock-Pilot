import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

enum OutOfStockSortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class OutofstockProvider extends FilterProviderInterface {
  late ProductProvider _productProvider;
  bool _isProviderSet = false;
  // Final filtered list
  List<ProductModel> filteredOutOfStock = [];
  // Search + sort
  String _searchQuery = "";
  OutOfStockSortOption _currentSort = OutOfStockSortOption.priceLowToHigh;
  OutOfStockSortOption get currentSort => _currentSort;
  // Selected filters
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};
  @override
  double maxPrice = 10000;
  @override
  double minPrice = 0;
  
  double selectedMaxPrice = 10000;
  double selectedMinPrice = 0;
  
  String stockStatus = 'All';
  // Temp filters (used in UI)
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
  // Check if any filter is active
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      selectedMinPrice > minPrice;
  // Get category and brand lists
  @override
  List<String> get categoryList =>
      _isProviderSet ? _productProvider.categoryList : [];
  @override
  List<String> get brandsList =>
      _isProviderSet ? _productProvider.brandsList : [];
  // Initialize temp filters
  @override
  void initTempFilters() {
    tempCategories = {...selectedCategories};
    tempBrands = {...selectedBrands};
    tempMaxPrice = selectedMaxPrice;
    tempMinPrice = selectedMinPrice;
    tempStockStatus = stockStatus;
    notifyListeners();
  }

  // Toggle category
  @override
  void toggleTempCategory(String cat) {
    tempCategories.contains(cat)
        ? tempCategories.remove(cat)
        : tempCategories.add(cat);
    notifyListeners();
  }

  // Toggle brand
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

  // Apply filters
  @override
  void applyFilters() {
    selectedCategories = {...tempCategories};
    selectedBrands = {...tempBrands};
    selectedMaxPrice = tempMaxPrice;
    selectedMinPrice = tempMinPrice;
    stockStatus = tempStockStatus;
    _applyOutOfStockLogic();
  }

  // Clear filters
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
    _applyOutOfStockLogic();
  }

  // Attach product provider
  void updateProductProvider(ProductProvider provider) {
    if (_isProviderSet) {
      _productProvider.removeListener(_onProductProviderChanged);
    }
    _productProvider = provider;
    _isProviderSet = true;
    final newMax = provider.maxPrice > 0 ? provider.maxPrice : maxPrice;
    final newMin = provider.minPrice;
    maxPrice = newMax;
    minPrice = newMin;
    selectedMaxPrice = newMax;
    selectedMinPrice = newMin;
    tempMaxPrice = newMax;
    tempMinPrice = newMin;
    _productProvider.addListener(_onProductProviderChanged);
    _applyOutOfStockLogic();
  }

  // Listen to product changes
  void _onProductProviderChanged() {
    final newMax = _productProvider.maxPrice > 0
        ? _productProvider.maxPrice
        : maxPrice;
    final newMin = _productProvider.minPrice;
    if (newMax == maxPrice && newMin == minPrice) {
      _applyOutOfStockLogic();
      return;
    }
    maxPrice = newMax;
    minPrice = newMin;
    if (selectedMaxPrice > maxPrice) selectedMaxPrice = maxPrice;
    if (selectedMinPrice < minPrice) selectedMinPrice = minPrice;
    if (tempMaxPrice > maxPrice) tempMaxPrice = maxPrice;
    if (tempMinPrice < minPrice) tempMinPrice = minPrice;
    _applyOutOfStockLogic();
  }

  @override
  void dispose() {
    if (_isProviderSet) {
      _productProvider.removeListener(_onProductProviderChanged);
    }
    super.dispose();
  }

  // Search
  void searchOutOfStock(String query) {
    _searchQuery = query;
    _applyOutOfStockLogic();
  }

  void clearSearch() {
    _searchQuery = "";
    _applyOutOfStockLogic();
  }

  // Sort
  void sortProducts(OutOfStockSortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  // Main logic
  void _applyOutOfStockLogic() {
    if (!_isProviderSet) return;
    // Get out-of-stock products
    List<ProductModel> result = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      return count == 0;
    }).toList();
    // Apply search
    result = SearchBarUtil.getFilteredList<ProductModel>(
      sourceList: result,
      query: _searchQuery,
      searchField: (p) => p.productName ?? "",
    );
    // Category filter
    if (selectedCategories.isNotEmpty) {
      result = result
          .where((p) => selectedCategories.contains(p.category))
          .toList();
    }
    // Brand filter
    if (selectedBrands.isNotEmpty) {
      result = result.where((p) => selectedBrands.contains(p.brand)).toList();
    }
    // Price filter
    result = result.where((p) {
      final price = double.tryParse(p.salesRate ?? '0') ?? 0;
      return price >= selectedMinPrice && price <= selectedMaxPrice;
    }).toList();
    filteredOutOfStock = result;
    _applySorting();
    notifyListeners();
  }

  // Sorting logic
  void _applySorting() {
    filteredOutOfStock.sort((a, b) {
      final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
      final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
      switch (_currentSort) {
        case OutOfStockSortOption.priceLowToHigh:
          return aPrice.compareTo(bPrice);
        case OutOfStockSortOption.priceHighToLow:
          return bPrice.compareTo(aPrice);
        case OutOfStockSortOption.alphabeticalAZ:
          return (a.productName ?? '').toLowerCase().compareTo(
            (b.productName ?? '').toLowerCase(),
          );
        case OutOfStockSortOption.alphabeticalZA:
          return (b.productName ?? '').toLowerCase().compareTo(
            (a.productName ?? '').toLowerCase(),
          );
      }
    });
  }
}
