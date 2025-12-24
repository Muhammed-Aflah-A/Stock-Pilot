// Hive Flutter adapter package
// Used to store this model in local Hive database
import 'package:hive_flutter/adapters.dart';

// Generated Hive adapter file
// This file is created automatically using build_runner
part 'drawer_model.g.dart';

/// DrawerItems
/// This model represents a single item in the app drawer.
/// It stores icon path, title text, and navigation route.

@HiveType(typeId: 1) // Unique Hive type ID for DrawerItems
class DrawerItems {
  // Path of the drawer icon image
  @HiveField(0)
  String? icon;

  // Title text shown in the drawer
  @HiveField(1)
  String? title;

  // Route name used for navigation when item is tapped
  @HiveField(2)
  String? navigation;

  // Constructor to create a drawer item
  DrawerItems({
    required this.title,
    required this.icon,
    required this.navigation,
  });
}
