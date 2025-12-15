import 'package:hive_flutter/adapters.dart';
part 'dasboard_model.g.dart';
@HiveType(typeId: 2)
class DasboardModel {
  @HiveField(0)
  String? image;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? product;
  @HiveField(3)
  String? category;
  @HiveField(4)
  int? unit;
  @HiveField(5)
  String? label;
  @HiveField(6)
  bool? isPositive;
  DasboardModel({
    required this.image,
    required this.title,
    required this.product,
    required this.category,
    required this.unit,
    required this.label,
    required this.isPositive,
  });
}
