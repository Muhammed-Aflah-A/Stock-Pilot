// Used to check platform (Android / iOS)
import 'dart:io';

// Used to get Android version info
import 'package:device_info_plus/device_info_plus.dart';

// Flutter core UI and ChangeNotifier
import 'package:flutter/material.dart';

// Used for picking images from camera or gallery
import 'package:image_picker/image_picker.dart';

// Used for requesting runtime permissions
import 'package:permission_handler/permission_handler.dart';

// App theme colors
import 'package:stock_pilot/core/theme/colours_styles.dart';

// User-related data models
import 'package:stock_pilot/data/models/user_profle_model.dart';

// Hive service layer for local storage
import 'package:stock_pilot/data/services/hive_service_layer.dart';

/// ProfilePageProvider
/// Responsible for:
/// - Loading user profile data from Hive
/// - Updating user data
/// - Handling camera & gallery permissions
/// - Updating profile image
/// - Providing profile data for UI lists
/// - Validating edited profile fields
class ProfilePageProvider with ChangeNotifier {
  // Hive service dependency
  final HiveServiceLayer hiveService;

  // Constructor: loads user data when provider is created
  ProfilePageProvider({required this.hiveService}) {
    loadUser();
  }

  // Holds the current user profile
  UserProfile? user;

  /// Loads user data from Hive database
  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

  /// Updates user data in Hive database
  Future<void> updateUser() async {
    await hiveService.updateUser(user!);
    notifyListeners();
  }

  /// Requests camera permission
  Future<PermissionStatus> cameraPermission() async {
    final status = await Permission.camera.request();
    return status;
  }

  /// Requests gallery / storage permission
  /// Handles Android version differences
  Future<PermissionStatus> libraryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Get Android OS version
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ uses photos permission
        status = await Permission.photos.request();
      } else {
        // Older Android versions use storage permission
        status = await Permission.storage.request();
      }
    } else {
      // Other platforms (iOS not handled here)
      status = PermissionStatus.denied;
    }

    return status;
  }

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  /// Opens device camera and updates profile image
  Future<void> openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      user?.profileImage = image.path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  /// Opens gallery and updates profile image
  Future<void> openLibrary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      user?.profileImage = image.path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  /// ================= PERSONAL INFO LIST =================
  /// Builds a list of personal information items
  /// Used in Profile page UI
  List<PersonalInfo> get personalInfo {
    return [
      PersonalInfo(
        leadingIcon: Icon(
          Icons.person_2_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Full Name",
        subtitle: user!.fullName,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'name',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.phone_android_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Phone number",
        subtitle: user!.personalNumber,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'personalNumber',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.mail_outline,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Email",
        subtitle: user!.gmail,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'email',
      ),
    ];
  }

  /// ================= SHOP INFO LIST =================
  /// Builds a list of shop-related information items
  List<ShopInfo> get shopInfo {
    return [
      ShopInfo(
        leadingIcon: Icon(
          Icons.store_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Name",
        subtitle: user!.shopName,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'shop name',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.location_on_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Address",
        subtitle: user!.shopAdress,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'address',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.phone_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Number",
        subtitle: user!.shopNumber,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'shopNumber',
      ),
    ];
  }

  /// Returns appropriate keyboard type based on field type
  TextInputType? getKeyboardType(String type) {
    switch (type.toLowerCase()) {
      case "name":
        return TextInputType.name;
      case "email":
        return TextInputType.emailAddress;
      case 'personalNumber':
        return TextInputType.phone;
      case 'shop name':
        return TextInputType.text;
      case 'shop address':
        return TextInputType.multiline;
      case 'shopNumber':
        return TextInputType.phone;
      default:
        return null;
    }
  }

  /// Validates input values based on field type
  String? validate(String? value, String type) {
    switch (type.toLowerCase()) {
      case 'name':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter your full name";
        }
        if (RegExp(r'\d').hasMatch(value)) {
          return "Name cannot contain numbers";
        }
        if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
          return "Name cannot contain special characters";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Name cannot contain multiple spaces together";
        }
        if (value.length < 3) {
          return "Name must be at least 3 characters";
        }
        return null;

      case 'personalNumber':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a phone number";
        }
        if (!value.startsWith('+')) {
          return "Phone number must start with +";
        }
        if (RegExp(r'\s').hasMatch(value)) {
          return "Phone number must not contain spaces";
        }
        if (!RegExp(r'^\+\d+$').hasMatch(value)) {
          return "Only numbers are allowed after +";
        }
        if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
          return "Enter a valid international phone number";
        }
        return null;

      case 'email':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a email";
        }
        if (!RegExp(r'^[a-z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;

      case 'shop name':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter you shop name";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Shop name cannot contain multiple spaces together";
        }
        return null;

      case 'shop address':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter your shop address";
        }
        if (value.length < 10) {
          return "Shop address must be at least 10 characters";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Shop address cannot contain multiple spaces together";
        }
        return null;

      case 'shopNumber':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a phone number";
        }
        if (!value.startsWith('+')) {
          return "Phone number must start with +";
        }
        if (RegExp(r'\s').hasMatch(value)) {
          return "Phone number must not contain spaces";
        }
        if (!RegExp(r'^\+\d+$').hasMatch(value)) {
          return "Only numbers are allowed after +";
        }
        if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
          return "Enter a valid international phone number";
        }
        return null;

      default:
        return null;
    }
  }
}
