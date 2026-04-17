import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class ImagePermissionUtil {
  static final deviceInfo = DeviceInfoPlugin();
  static Future<PermissionStatus> cameraPermission() async {
    if (kIsWeb) return PermissionStatus.granted;
    return await Permission.camera.request();
  }

  static Future<PermissionStatus> libraryPermission() async {
    if (kIsWeb) return PermissionStatus.granted;
    try {
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return await Permission.photos.request();
      }
      return await Permission.storage.request();
    } catch (_) {
      return PermissionStatus.denied;
    }
  }
}

