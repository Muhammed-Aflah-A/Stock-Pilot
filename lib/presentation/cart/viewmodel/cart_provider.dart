import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/history/viewmodel/history_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class CartProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;

  CartProvider({required this.hiveService}) {
    loadCart();
  }

  List<CartItems> cartItems = [];
  String? customerName;
  String? customerNumber;
  String? billingDate;
  final formKey = GlobalKey<FormState>();
  bool get isFormValid => formKey.currentState?.validate() ?? false;
  final customerNumberFocus = FocusNode();
  Future<void> loadCart() async {
    cartItems = await hiveService.getCartItems();
    notifyListeners();
  }

  Future<bool> addItem(ProductModel product) async {
    final stock = int.tryParse(product.itemCount ?? '0') ?? 0;
    if (stock <= 0) {
      return false;
    }
    final index = cartItems.indexWhere(
      (item) => item.product.productName == product.productName,
    );

    if (index != -1) {
      if (cartItems[index].quantity >= stock) {
        return false;
      }
      final updatedItem = CartItems(
        product: cartItems[index].product,
        quantity: cartItems[index].quantity + 1,
      );
      await hiveService.updateCartItem(index, updatedItem);
    } else {
      final newItem = CartItems(product: product, quantity: 1);
      await hiveService.addToCart(newItem);
    }
    await loadCart();
    return true;
  }

  Future<void> removeItem(CartItems item) async {
    final index = cartItems.indexOf(item);
    if (index != -1) {
      await hiveService.removeFromCart(index);
      await loadCart();
    }
  }

  Future<bool> increaseQty(CartItems item) async {
    final index = cartItems.indexOf(item);
    if (index == -1) return false;
    final stock = int.tryParse(item.product.itemCount ?? '0') ?? 0;
    if (cartItems[index].quantity >= stock) {
      return false;
    }
    final updatedItem = CartItems(
      product: cartItems[index].product,
      quantity: cartItems[index].quantity + 1,
    );
    await hiveService.updateCartItem(index, updatedItem);
    await loadCart();
    return true;
  }

  Future<void> decreaseQty(CartItems item) async {
    final index = cartItems.indexOf(item);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        final updatedItem = CartItems(
          product: cartItems[index].product,
          quantity: cartItems[index].quantity - 1,
        );
        await hiveService.updateCartItem(index, updatedItem);
      } else {
        await hiveService.removeFromCart(index);
      }
      await loadCart();
    }
  }

  Future<bool> setQuantity(CartItems item, int newQty) async {
    final index = cartItems.indexOf(item);
    if (index == -1) return false;
    final updatedItem = CartItems(
      product: cartItems[index].product,
      quantity: newQty,
    );
    await hiveService.updateCartItem(index, updatedItem);
    await loadCart();
    return true;
  }

  int getQuantity(CartItems item) => item.quantity;

  int get totalItems {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      final price = double.tryParse(item.product.salesRate ?? '0') ?? 0;
      total += price * item.quantity;
    }
    return total;
  }

  void setCustomerName(String? value) {
    customerName = value?.trim();
  }

  void setCustomerNumber(String? value) {
    customerNumber = value?.trim();
  }

  void setBillingDate(String? value) {
    billingDate = value;
  }

  Future<SalesItems?> completeSale({
    required ProductProvider productProvider,
    required DashboardProvider dashboardProvider,
    required HistoryProvider historyProvider,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return null;
    }
    formKey.currentState!.save();
    for (var item in cartItems) {
      final stock = int.tryParse(item.product.itemCount ?? '0') ?? 0;
      if (item.quantity <= 0 || item.quantity > stock) {
        return null;
      }
    }
    final sale = SalesItems(
      customerName: customerName,
      customerNumber: customerNumber,
      date: DateFormat('dd - MMM - yyyy', 'en_US').format(DateTime.now()),
      items: List.from(cartItems),
      totalAmount: totalPrice,
    );
    for (var item in cartItems) {
      final index = productProvider.products.indexWhere(
        (p) => p.productName == item.product.productName,
      );
      if (index != -1) {
        final product = productProvider.products[index];
        final currentStock = int.tryParse(product.itemCount ?? '0') ?? 0;
        final updatedStock = currentStock - item.quantity;
        product.itemCount = updatedStock.toString();
        await hiveService.updateProduct(index, product);
        await dashboardProvider.addNewActivity(
          DasboardActivity(
            image: product.productImages.isNotEmpty
                ? product.productImages[0]
                : null,
            title: 'Item Sold',
            product: product.productName,
            category: product.category,
            unit: item.quantity,
            label: 'units sold',
            isPositive: false,
            date: DateFormat('dd - MMM - yyyy', 'en_US').format(DateTime.now()),
            customerName: customerName,
            customerNumber: customerNumber,
            brand: product.brand,
          ),
        );
      }
    }
    await historyProvider.addSale(sale);
    formKey.currentState?.reset();
    await clearCart();
    await productProvider.loadProducts();
    return sale;
  }

  Future<void> clearCart() async {
    await hiveService.clearCart();
    await loadCart();
  }
}

