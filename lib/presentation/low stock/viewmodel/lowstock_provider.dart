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
  // Final filtered result
  List<ProductModel> filteredLowStock = [];
  // Search + sort
  String _searchQuery = "";
  LowStockSortOption _currentSort = LowStockSortOption.priceLowToHigh;
  LowStockSortOption get currentSort => _currentSort;
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
  // Temp values (bottom sheet)
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
  // Check active filters
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice ||
      selectedMinPrice > minPrice;
  // Lists from low stock subset
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
  // Init temp filters
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
    _applyLowStockSearch();
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
    _applyLowStockSearch();
  }

  // Attach product provider
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

  // Update filter bounds based on current low stock items
  void _updateFilterBounds() {
    if (!_isProviderSet) return;
    
    // Get the base list of low stock items (no filters applied yet)
    final baseList = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();

    // Update categories and brands
    categoryList = baseList.map((p) => p.category).whereType<String>().toSet().toList();
    brandsList = baseList.map((p) => p.brand).whereType<String>().toSet().toList();

    // Update price bounds
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

  // Listen for product changes (FIXED)
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

  // Search
  void searchLowStock(String query) {
    _searchQuery = query;
    _applyLowStockSearch();
  }

  void clearSearch() {
    _searchQuery = "";
    _applyLowStockSearch();
  }

  // Sort
  void sortProducts(LowStockSortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  // MAIN LOGIC (filter + search)
  void _applyLowStockSearch() {
    if (!_isProviderSet) return;
    List<ProductModel> result = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();
    // Search
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
    filteredLowStock = result;
    _applySorting();
    notifyListeners();
  }

  // Sorting logic
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
