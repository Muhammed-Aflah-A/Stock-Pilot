import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProfileCreationProvider with ChangeNotifier {
  String? profileImage;
  final formKey = GlobalKey<FormState>();
  String? fullName;
  final shopNameFocus = FocusNode();
  String? shopName;
  final shopAdressFocus = FocusNode();
  String? shopAdress;
  final shopNumberFocus = FocusNode();
  String? shopNumber;
  final personalNumberFocus = FocusNode();
  String? personalNumber;
  final emailFocus = FocusNode();
  String? gmail;
  final HiveServiceLayer hiveService;
  ProfileCreationProvider({required this.hiveService});
  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }

  Future<PermissionStatus> cameraPermission() async {
    final status = await Permission.camera.request();
    return status;
  }

  Future<PermissionStatus> libraryPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = PermissionStatus.denied;
    }
    return status;
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      profileImage = image.path;
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage = image.path;
      notifyListeners();
    }
  }
}
