// Provider for the profile creation flow.
// This class manages form data, image picking,
// permission handling, and saving user profile data.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// User profile model
import 'package:stock_pilot/data/models/user_profle_model.dart';

// Hive service layer for saving data locally
import 'package:stock_pilot/data/services/hive_service_layer.dart';

/// ProfileCreationProvider
/// This provider is responsible for:
/// - Holding profile form values
/// - Managing focus between form fields
/// - Requesting camera and gallery permissions
/// - Picking images from camera or gallery
/// - Saving the user profile using Hive
class ProfileCreationProvider with ChangeNotifier {
  // ================= FORM STATE =================

  // Stores selected profile image path
  String? profileImage;

  // Key used to validate and save the form
  final formKey = GlobalKey<FormState>();

  // User full name
  String? fullName;

  // Focus node for shop name field
  final shopNameFocus = FocusNode();

  // Shop name value
  String? shopName;

  // Focus node for shop address field
  final shopAdressFocus = FocusNode();

  // Shop address value
  String? shopAdress;

  // Focus node for shop phone number field
  final shopNumberFocus = FocusNode();

  // Shop phone number value
  String? shopNumber;

  // Focus node for personal phone number field
  final personalNumberFocus = FocusNode();

  // Personal phone number value
  String? personalNumber;

  // Focus node for email field
  final emailFocus = FocusNode();

  // Email value
  String? gmail;

  // ================= SERVICES =================

  // Hive service used to store user data locally
  final HiveServiceLayer hiveService;

  // Constructor requiring Hive service dependency
  ProfileCreationProvider({required this.hiveService});

  /// Saves the user profile data into Hive database
  Future<void> addUser(UserProfile user) async {
    // Persist the user profile using Hive service
    await hiveService.addUser(user);
  }

  /// Requests camera permission from the system
  /// Returns the permission status
  Future<PermissionStatus> cameraPermission() async {
    final status = await Permission.camera.request();
    return status;
  }

  /// Requests gallery/library permission
  /// Handles Android version differences
  Future<PermissionStatus> libraryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Get Android device info
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ requires photos permission
        status = await Permission.photos.request();
      } else {
        // Older Android versions use storage permission
        status = await Permission.storage.request();
      }
    } else {
      // For iOS or unsupported platforms (not handled here)
      status = PermissionStatus.denied;
    }

    return status;
  }

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  /// Opens device camera and lets user take a photo
  /// Stores the selected image path
  Future<void> openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      profileImage = image.path;

      // Notify UI to rebuild with new image
      notifyListeners();
    }
  }

  /// Opens gallery/library and lets user pick an image
  /// Stores the selected image path
  Future<void> openLibrary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImage = image.path;

      // Notify UI to rebuild with new image
      notifyListeners();
    }
  }
}
