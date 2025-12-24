// Flutter material package (used here for Icon class)
import 'package:flutter/material.dart';

// Hive package for local database storage
import 'package:hive/hive.dart';

// Generated Hive adapter file (created using build_runner)
part 'user_profle_model.g.dart';

/// ================= USER PROFILE MODEL =================
/// This model represents the main user profile data
/// stored locally using Hive.

@HiveType(typeId: 0) // Unique Hive type ID for UserProfile
class UserProfile {
  // Path of the profile image (stored as String)
  @HiveField(0)
  String? profileImage;

  // User's full name
  @HiveField(1)
  String? fullName;

  // User's personal phone number
  @HiveField(2)
  String? personalNumber;

  // Shop name
  @HiveField(3)
  String? shopName;

  // Shop address
  @HiveField(4)
  String? shopAdress;

  // Shop phone number
  @HiveField(5)
  String? shopNumber;

  // User's email (gmail)
  @HiveField(6)
  String? gmail;

  // Constructor for creating a UserProfile object
  UserProfile({
    this.profileImage,
    required this.fullName,
    required this.personalNumber,
    required this.shopName,
    required this.shopAdress,
    required this.shopNumber,
    required this.gmail,
  });
}

/// ================= PERSONAL INFO MODEL =================
/// This model is used to display personal information
/// in UI lists (for example: profile page list tiles).

@HiveType(typeId: 4) // Unique Hive type ID for PersonalInfo
class PersonalInfo {
  // Icon shown at the start of the list tile
  @HiveField(0)
  Icon? leadingIcon;

  // Title text (e.g., "Name", "Email")
  @HiveField(1)
  String? title;

  // Value text shown below the title
  @HiveField(2)
  String? subtitle;

  // Icon shown at the end of the list tile (e.g., edit icon)
  @HiveField(3)
  Icon? trailingIcon;

  // Field identifier used for editing logic
  @HiveField(4)
  String? feildtype;

  // Constructor
  PersonalInfo({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.feildtype,
  });
}

/// ================= SHOP INFO MODEL =================
/// This model is similar to PersonalInfo but used
/// specifically for shop-related details.

@HiveType(typeId: 5) // Unique Hive type ID for ShopInfo
class ShopInfo {
  // Icon shown at the start of the list tile
  @HiveField(0)
  Icon? leadingIcon;

  // Title text (e.g., "Shop Name")
  @HiveField(1)
  String? title;

  // Value text shown below the title
  @HiveField(2)
  String? subtitle;

  // Icon shown at the end of the list tile
  @HiveField(3)
  Icon? trailingIcon;

  // Field identifier for edit handling
  @HiveField(4)
  String? feildtype;

  // Constructor
  ShopInfo({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.feildtype,
  });
}
