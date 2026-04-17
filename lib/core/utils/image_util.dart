import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';

class ImageUtil {
  static ImageProvider getProfileImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage(AppImages.profilePicture);
    }
    if (kIsWeb) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (!file.existsSync()) {
      return const AssetImage(AppImages.profilePicture);
    }
    return FileImage(file);
  }

  static ImageProvider getProductImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage(AppImages.productImage1);
    }
    if (kIsWeb) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (!file.existsSync()) {
      return const AssetImage(AppImages.productImage1);
    }
    return FileImage(file);
  }

   static Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = image.path.split('/').last;
    final newPath = '${directory.path}/$fileName';
    final newImage = await image.copy(newPath);
    return newImage.path;
  }
}

