import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

// Utility class responsible for requesting image-related permissions
class ImagePermissionUtil {
  static final deviceInfo = DeviceInfoPlugin();
  // DeviceInfoPlugin instance used to detect Android SDK version.
  static Future<PermissionStatus> cameraPermission() async {
    // On web permissions are handled by the browser, so we return `granted`.
    if (kIsWeb) return PermissionStatus.granted;
    // On mobile request camera permission using permission_handler.
    return await Permission.camera.request();
  }

  static Future<PermissionStatus> libraryPermission() async {
    // Web automatically returns granted because the browser manages permissions.
    if (kIsWeb) return PermissionStatus.granted;
    try {
      // Get Android device information to determine SDK version
      final androidInfo = await deviceInfo.androidInfo;
      // Android 13+ requires photos permission instead of storage
      if (androidInfo.version.sdkInt >= 33) {
        return await Permission.photos.request();
      }
      // Older Android versions require storage permission
      return await Permission.storage.request();
    } catch (_) {
      // If any error occurs while fetching device info, return denied to safely block access.
      return PermissionStatus.denied;
    }
  }
}
