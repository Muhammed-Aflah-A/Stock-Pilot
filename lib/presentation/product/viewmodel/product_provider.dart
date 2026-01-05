import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/service/image_permission.dart';
import 'package:stock_pilot/core/service/image_selector.dart';

class ProductProvider with ChangeNotifier {
  final ImagePermission imagePermission;
  final ImageSelector imageSelector;
  ProductProvider({required this.imagePermission, required this.imageSelector});

  List<File?> productImages = List.generate(4, (_) => null);

  Future<PermissionStatus> cameraPermission() async {
    return imagePermission.cameraPermission();
  }

  Future<PermissionStatus> libraryPermission() async {
    return imagePermission.libraryPermission();
  }

  Future<void> openCamera([int? index]) async {
    final path = await imageSelector.openCamera();
    if (path != null) {
      if (index != null) {
        productImages[index] = File(path);
      }
      notifyListeners();
    }
  }

  Future<void> openLibrary([int? index]) async {
    final path = await imageSelector.openLibrary();
    if (path != null) {
      if (index != null) {
        productImages[index] = File(path);
      }
      notifyListeners();
    }
  }

  void removeImage(int index) {
    productImages[index] = null;
    notifyListeners();
  }
}
