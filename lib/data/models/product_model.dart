import 'package:hive_flutter/adapters.dart';
part 'product_model.g.dart';
@HiveType(typeId: 6)
class ProductModel {
  @HiveField(0)
  List<String> images;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String brand;
  @HiveField(4)
  String category;
  @HiveField(5)
  double purchaseRate;
  @HiveField(6)
  double salesRate;
  @HiveField(7)
  int itemCount;
  @HiveField(8)
  int lowStockCount;
  ProductModel({
    required this.images,
    required this.name,
    required this.description,
    required this.brand,
    required this.category,
    required this.purchaseRate,
    required this.salesRate,
    required this.itemCount,
    required this.lowStockCount,
  });
}
