import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class ImagePermissionUtil {
  static Future<PermissionStatus> cameraPermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    final status = await Permission.camera.request();
    return status;
  }

  static Future<PermissionStatus> libraryPermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    PermissionStatus status;
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } catch (e) {
      status = PermissionStatus.denied;
    }
    return status;
  }
}
