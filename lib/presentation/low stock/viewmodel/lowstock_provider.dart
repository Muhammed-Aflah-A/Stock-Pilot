import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/search_bar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

enum LowStockSortOption {
  priceLowToHigh,
  priceHighToLow,
  alphabeticalAZ,
  alphabeticalZA,
}

class LowstockProvider with ChangeNotifier {
  late ProductProvider _productProvider;
  List<ProductModel> filteredLowStock = [];
  String _searchQuery = "";
  LowStockSortOption _currentSort = LowStockSortOption.priceLowToHigh;
  LowStockSortOption get currentSort => _currentSort;
  void updateProductProvider(ProductProvider provider) {
    _productProvider = provider;
    _applyLowStockSearch();
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
    final lowStockList = _productProvider.products.where((product) {
      final count = int.tryParse(product.itemCount ?? '0') ?? 0;
      final lowStock = int.tryParse(product.lowStockCount ?? '0') ?? 0;
      return count <= lowStock && count > 0;
    }).toList();
    filteredLowStock = SearchBarUtil.getFilteredList<ProductModel>(
      sourceList: lowStockList,
      query: _searchQuery,
      searchField: (product) => product.productName ?? "",
    );
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
