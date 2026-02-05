import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 7)
class CategoryModel {
  @HiveField(0)
  String? category;
  CategoryModel({required this.category});
}
