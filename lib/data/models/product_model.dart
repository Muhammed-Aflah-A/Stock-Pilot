import 'package:hive_flutter/adapters.dart';
part 'product_model.g.dart';

@HiveType(typeId: 5)
class ProductModel {
  @HiveField(0)
  List<String> productImages;
  @HiveField(1)
  String? productName;
  @HiveField(2)
  String? productDescription;
  @HiveField(3)
  String? brand;
  @HiveField(4)
  String? category;
  @HiveField(5)
  String? purchaseRate;
  @HiveField(6)
  String?salesRate;
  @HiveField(7)
  String? itemCount;
  @HiveField(8)
  String? lowStockCount;

  ProductModel({
    required this.productImages,
    required this.productName,
    required this.productDescription,
    required this.brand,
    required this.category,
    required this.purchaseRate,
    required this.salesRate,
    required this.itemCount,
    required this.lowStockCount,
  });
}
