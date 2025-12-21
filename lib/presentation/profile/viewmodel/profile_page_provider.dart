import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProfilePageProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  ProfilePageProvider({required this.hiveService}) {
    loadUser();
  }
  UserProfile? user;
  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

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
      user?.profileImage = image.path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    // Open gallery/library and store selected image path
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      user?.profileImage = image.path;
      notifyListeners();
    }
  }
}
