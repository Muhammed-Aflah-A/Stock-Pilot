import 'package:hive_flutter/adapters.dart';
part 'drawer_model.g.dart';

@HiveType(typeId: 1)
class DrawerItems {
  @HiveField(0)
  String? icon;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? navigation;
  DrawerItems({
    required this.title,
    required this.icon,
    required this.navigation,
  });
}
