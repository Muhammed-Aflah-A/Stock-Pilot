import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';

class ImageUtil {
  static ImageProvider getProfileImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage(AppImages.profilePicture);
    }
    if (kIsWeb) {
      try {
        return NetworkImage(path);
      } catch (e) {
        debugPrint("Error loading web image: $e");
        return const AssetImage(AppImages.profilePicture);
      }
    } else {
      return _getMobileImage(path);
    }
  }

  static ImageProvider _getMobileImage(String path) {
    return const AssetImage(AppImages.profilePicture);
  }
}
