// Flutter material package
// Used here mainly for TextStyle
import 'package:flutter/material.dart';

// Hive Flutter adapter for local database storage
import 'package:hive_flutter/adapters.dart';

// Generated Hive adapter file
part 'dasboard_model.g.dart';

/// ================= DASHBOARD CARDS MODEL =================
/// This model represents a summary card shown on the dashboard
/// (for example: Total Products, Low Stock count, etc.)

@HiveType(typeId: 2) // Unique Hive type ID for DashboardCards
class DashboardCards {
  // Title of the dashboard card
  @HiveField(0)
  String? title;

  // Value displayed on the card
  @HiveField(1)
  String? value;

  // Text style for the title
  @HiveField(2)
  TextStyle? titleStyle;

  // Text style for the value
  @HiveField(3)
  TextStyle? valueStyle;

  // Constructor
  DashboardCards({
    required this.title,
    required this.value,
    required this.titleStyle,
    required this.valueStyle,
  });
}

/// ================= DASHBOARD ACTIVITY MODEL =================
/// This model represents a single recent activity item
/// shown in the dashboard activity list.

@HiveType(typeId: 3) // Unique Hive type ID for DasboardActivity
class DasboardActivity {
  // Image path related to the activity
  @HiveField(0)
  String? image;

  // Activity title (e.g., Stock Added / Stock Removed)
  @HiveField(1)
  String? title;

  // Product name related to the activity
  @HiveField(2)
  String? product;

  // Category name of the product
  @HiveField(3)
  String? category;

  // Unit change value (positive or negative)
  @HiveField(4)
  int? unit;

  // Label describing the activity time or status
  @HiveField(5)
  String? label;

  // Indicates whether the activity is positive or negative
  @HiveField(6)
  bool? isPositive;

  // Constructor
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
