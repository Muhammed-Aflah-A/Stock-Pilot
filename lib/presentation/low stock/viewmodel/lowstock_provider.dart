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
  double selectedMaxPrice = 10000;
  String stockStatus = 'All';
  // Temp values (bottom sheet)
  @override
  Set<String> tempCategories = {};
  @override
  Set<String> tempBrands = {};
  @override
  double tempMaxPrice = 10000;
  @override
  String tempStockStatus = 'All';
  @override
  bool get showStockFilter => false;
  // Check active filters
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice;
  // Lists from product provider
  @override
  List<String> get categoryList =>
      _isProviderSet ? _productProvider.categoryList : [];
  @override
  List<String> get brandsList =>
      _isProviderSet ? _productProvider.brandsList : [];
  // Init temp filters
  @override
  void initTempFilters() {
    tempCategories = {...selectedCategories};
    tempBrands = {...selectedBrands};
    tempMaxPrice = selectedMaxPrice;
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
  void setTempMaxPrice(double value) {
    tempMaxPrice = value;
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
    stockStatus = tempStockStatus;
    _applyLowStockSearch();
  }

  // Clear filters
  @override
  void clearFilters() {
    selectedCategories.clear();
    selectedBrands.clear();
    selectedMaxPrice = maxPrice;
    stockStatus = 'All';
    tempCategories.clear();
    tempBrands.clear();
    tempMaxPrice = maxPrice;
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
    // Sync max price safely
    final newMax = provider.maxPrice > 0 ? provider.maxPrice : maxPrice;
    maxPrice = newMax;
    selectedMaxPrice = newMax;
    tempMaxPrice = newMax;
    _productProvider.addListener(_onProductProviderChanged);
    _applyLowStockSearch();
  }

  // Listen for product changes (FIXED)
  void _onProductProviderChanged() {
    final newMax = _productProvider.maxPrice > 0
        ? _productProvider.maxPrice
        : maxPrice;
    // If no change → just refresh list
    if (newMax == maxPrice) {
      _applyLowStockSearch();
      return;
    }
    maxPrice = newMax;
    // Clamp only if needed (prevents unwanted resets)
    if (selectedMaxPrice > maxPrice) {
      selectedMaxPrice = maxPrice;
    }
    if (tempMaxPrice > maxPrice) {
      tempMaxPrice = maxPrice;
    }
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
      return price <= selectedMaxPrice;
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
