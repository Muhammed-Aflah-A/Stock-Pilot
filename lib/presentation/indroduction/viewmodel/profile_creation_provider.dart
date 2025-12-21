// Provider for the profile creation flow.
// Handles form state, image picking and permission checks.
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

/// Manages profile creation data and actions.
/// - Holds form fields and focus nodes
/// - Provides methods to request permissions and pick images
/// - Persists the created `UserProfile` via `HiveServiceLayer`
class ProfileCreationProvider with ChangeNotifier {
  // --- Form state and focus nodes ---
  String? profileImage;
  final formKey = GlobalKey<FormState>();
  String? fullName;
  final shopNameFocus = FocusNode();
  String? shopName;
  final shopAdressFocus = FocusNode();
  String? shopAdress;
  final phoneNumberFocus = FocusNode();
  String? phoneNumber;
  final emailFocus = FocusNode();
  String? gmail;

  final HiveServiceLayer hiveService;
  ProfileCreationProvider({required this.hiveService});

  Future<PermissionStatus> cameraPermission() async {
    // Request camera permission and return the resulting status.
    final status = await Permission.camera.request();
    return status;
  }

  Future<PermissionStatus> libraryPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // For Android 13+ use the photos permission
        status = await Permission.photos.request();
      } else {
        // For older Android versions use storage permission
        status = await Permission.storage.request();
      }
    } else {
      // iOS and other platforms should be handled as needed; default to denied
      status = PermissionStatus.denied;
    }
    return status;
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> openCamera() async {
    // Launch device camera and store selected image path
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      profileImage = image.path;
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    // Open gallery/library and store selected image path
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage = image.path;
      notifyListeners();
    }
  }

  Future<void> addUser(UserProfile user) async {
    // Persist the user profile using Hive service
    await hiveService.addUser(user);
  }
}
