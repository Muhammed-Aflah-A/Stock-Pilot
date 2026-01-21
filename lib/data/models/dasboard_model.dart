import 'package:hive_flutter/adapters.dart';
part 'dasboard_model.g.dart';

@HiveType(typeId: 2)
class DashboardCards {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? value;
  DashboardCards({
    required this.title,
    required this.value,
  });
}

@HiveType(typeId: 3)
class DasboardActivity {
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
  DasboardActivity({
    required this.image,
    required this.title,
    required this.product,
    required this.category,
    required this.unit,
    required this.label,
    required this.isPositive,
  });
}
