import 'package:hive_flutter/adapters.dart';
part 'brand_model.g.dart';
@HiveType(typeId: 8)
class BrandModel {
  @HiveField(0)
  String? brand;
  BrandModel({required this.brand});
}
