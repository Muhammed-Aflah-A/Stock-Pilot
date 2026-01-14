import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/service/image_permission.dart';
import 'package:stock_pilot/core/service/image_selector.dart';
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
  final ImagePermission imagePermission;
  final ImageSelector imageSelector;
  ProfileCreationProvider({
    required this.hiveService,
    required this.imagePermission,
    required this.imageSelector,
  });
  Future<PermissionStatus> cameraPermission() async {
    return imagePermission.cameraPermission();
  }

  Future<PermissionStatus> libraryPermission() async {
    return imagePermission.libraryPermission();
  }

  Future<void> openCamera() async {
    final path = await imageSelector.openCamera();
    if (path != null) {
      profileImage = path;
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    final path = await imageSelector.openLibrary();
    if (path != null) {
      profileImage = path;
      notifyListeners();
    }
  }

  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }
}
