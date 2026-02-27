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
  List<ProductModel> filteredLowStock = [];
  String _searchQuery = "";
  LowStockSortOption _currentSort = LowStockSortOption.priceLowToHigh;
  LowStockSortOption get currentSort => _currentSort;
  bool _isProviderSet = false;
  Set<String> selectedCategories = {};
  Set<String> selectedBrands = {};
  @override
  double maxPrice = 5000;
  double selectedMaxPrice = 5000;
  String stockStatus = 'All';
  @override
  Set<String> tempCategories = {};
  @override
  Set<String> tempBrands = {};
  @override
  double tempMaxPrice = 5000;
  @override
  String tempStockStatus = 'All';
  @override
  bool get showStockFilter => false;
  @override
  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedMaxPrice < maxPrice;
  @override
  List<String> get categoryList =>
      _isProviderSet ? _productProvider.categoryList : [];
  @override
  List<String> get brandsList =>
      _isProviderSet ? _productProvider.brandsList : [];
  @override
  void initTempFilters() {
    tempCategories = Set.from(selectedCategories);
    tempBrands = Set.from(selectedBrands);
    tempMaxPrice = selectedMaxPrice;
    tempStockStatus = stockStatus;
    notifyListeners();
  }

  @override
  void toggleTempCategory(String cat) {
    tempCategories = Set.from(tempCategories);
    tempCategories.contains(cat)
        ? tempCategories.remove(cat)
        : tempCategories.add(cat);
    notifyListeners();
  }

  @override
  void toggleTempBrand(String brand) {
    tempBrands = Set.from(tempBrands);
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

  @override
  void applyFilters() {
    selectedCategories = Set.from(tempCategories);
    selectedBrands = Set.from(tempBrands);
    selectedMaxPrice = tempMaxPrice;
    stockStatus = tempStockStatus;
    _applyLowStockSearch();
  }

  @override
  void clearFilters() {
    selectedCategories = {};
    selectedBrands = {};
    selectedMaxPrice = maxPrice;
    stockStatus = 'All';
    tempCategories = {};
    tempBrands = {};
    tempMaxPrice = maxPrice;
    tempStockStatus = 'All';
    _applyLowStockSearch();
    notifyListeners();
  }

  void updateProductProvider(ProductProvider provider) {
    if (_isProviderSet) {
      _productProvider.removeListener(_onProductProviderChanged);
    }
    _productProvider = provider;
    _isProviderSet = true;
    maxPrice = provider.maxPrice > 0 ? provider.maxPrice : 5000;
    selectedMaxPrice = maxPrice;
    tempMaxPrice = maxPrice;
    _productProvider.addListener(_onProductProviderChanged);
    _applyLowStockSearch();
  }

  void _onProductProviderChanged() {
    final double newMax = _productProvider.maxPrice > 0
        ? _productProvider.maxPrice
        : 5000;
    if (newMax != maxPrice) {
      maxPrice = newMax;
      if (selectedMaxPrice > maxPrice) selectedMaxPrice = maxPrice;
      if (tempMaxPrice > maxPrice) tempMaxPrice = maxPrice;
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
      searchField: (product) => product.productName ?? "",
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
      return price <= selectedMaxPrice;
    }).toList();
    filteredLowStock = result;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    filteredLowStock.sort((a, b) {
      switch (_currentSort) {
        case LowStockSortOption.priceLowToHigh:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
          return aPrice.compareTo(bPrice);
        case LowStockSortOption.priceHighToLow:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
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
