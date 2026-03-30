import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/sales_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class CartProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;

  CartProvider({required this.hiveService}) {
    loadCart();
  }

  // Cart items
  List<CartItems> cartItems = [];
  // Variable used to store data
  String? customerName;
  String? customerNumber;
  String? billingDate;
  // Global key used to manage and validate the form
  final formKey = GlobalKey<FormState>();
  // Exposes current form validity safely
  bool get isFormValid => formKey.currentState?.validate() ?? false;
  // Focus node for moving focus from one form to another
  final customerNumberFocus = FocusNode();
  // Load Cart items
  Future<void> loadCart() async {
    cartItems = await hiveService.getCartItems();
    notifyListeners();
  }

  // Add items to the cart
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

  // Remove items from the cart
  Future<void> removeItem(CartItems item) async {
    final index = cartItems.indexOf(item);
    if (index != -1) {
      await hiveService.removeFromCart(index);
      await loadCart();
    }
  }

  // Quantity control
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

  // Setting quantity
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

  // Total checking
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

  // Setter for customer name name
  void setCustomerName(String? value) {
    customerName = value?.trim();
  }

  // Setter for customer number
  void setCustomerNumber(String? value) {
    customerNumber = value?.trim();
  }

  // Setter for billing date
  void setBillingDate(String? value) {
    billingDate = value;
  }

  // Adding sales
  Future<SalesItems?> completeSale({
    required ProductProvider productProvider,
    required DashboardProvider dashboardProvider,
    required SalesProvider salesProvider,
  }) async {
    // Validate form
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
    // Create sale object
    final sale = SalesItems(
      customerName: customerName,
      customerNumber: customerNumber,
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      items: List.from(cartItems),
      totalAmount: totalPrice,
    );
    // Reduce stock + activity
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
          ),
        );
      }
    }
    // Save sales
    await salesProvider.addSale(sale);
    formKey.currentState?.reset();
    // Clear cart
    await clearCart();
    return sale;
  }

  // Clearing from cart
  Future<void> clearCart() async {
    await hiveService.clearCart();
    await loadCart();
  }
}
