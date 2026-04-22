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
    if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
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
    if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (!file.existsSync()) {
      return const AssetImage(AppImages.productImage1);
    }
    return FileImage(file);
  }

  static Future<String> saveImage(String path) async {
    if (kIsWeb) return path; // On web, we return the blob URL or handle persistence in the provider
    
    final file = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.split('/').last;
    final newPath = '${directory.path}/$fileName';
    final newImage = await file.copy(newPath);
    return newImage.path;
  }
}

