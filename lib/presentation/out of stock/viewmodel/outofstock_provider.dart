import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

enum OutOfStockSortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class OutofstockProvider with ChangeNotifier {
  late ProductProvider _productProvider;

  List<ProductModel> filteredOutOfStock = [];
  String _searchQuery = "";
  OutOfStockSortOption _currentSort = OutOfStockSortOption.priceLowToHigh;
  OutOfStockSortOption get currentSort => _currentSort;
  void updateProductProvider(ProductProvider provider) {
    _productProvider = provider;
    _applyOutOfStockLogic();
  }

  void loadOutOfStock() {
    _applyOutOfStockLogic();
    notifyListeners();
  }

  void searchOutOfStock(String query) {
    _searchQuery = query;
    _applyOutOfStockLogic();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = "";
    _applyOutOfStockLogic();
    notifyListeners();
  }

  void _applyOutOfStockLogic() {
    final outOfStockList = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      return count == 0;
    }).toList();
    filteredOutOfStock = SearchBarUtil.getFilteredList<ProductModel>(
      sourceList: outOfStockList,
      query: _searchQuery,
      searchField: (product) => product.productName ?? "",
    );
    _applySorting();
  }

  void sortProducts(OutOfStockSortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    filteredOutOfStock.sort((a, b) {
      switch (_currentSort) {
        case OutOfStockSortOption.priceLowToHigh:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
          return aPrice.compareTo(bPrice);
        case OutOfStockSortOption.priceHighToLow:
          final aPrice = double.tryParse(a.salesRate ?? '0') ?? 0;
          final bPrice = double.tryParse(b.salesRate ?? '0') ?? 0;
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
