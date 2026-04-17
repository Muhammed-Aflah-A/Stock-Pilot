import 'package:hive/hive.dart';
import 'package:stock_pilot/data/models/product_model.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 8)
class CartItems {
  @HiveField(0)
  final ProductModel product;
  @HiveField(1)
  int quantity;
  CartItems({required this.product, this.quantity = 1});
}

@HiveType(typeId: 9)
class SalesItems {
  @HiveField(0)
  final String? customerName;
  @HiveField(1)
  final String? customerNumber;
  @HiveField(2)
  final String date;
  @HiveField(3)
  final List<CartItems> items;
  @HiveField(4)
  final double totalAmount;
  SalesItems({
    required this.customerName,
    required this.customerNumber,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}

