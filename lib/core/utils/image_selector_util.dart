import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageSelectorUtil {
  static final ImagePicker picker = ImagePicker();

  static Future<String?> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      return 'data:image/png;base64,${base64Encode(bytes)}';
    }
    return image.path;
  }

  static Future<String?> openLibrary() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image == null) return null;
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      return 'data:image/png;base64,${base64Encode(bytes)}';
    }
    return image.path;
  }

  static Future<List<String>?> openLibraryMulti() async {
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (images.isEmpty) return null;

    if (kIsWeb) {
      final List<String> base64Images = [];
      for (final image in images) {
        final bytes = await image.readAsBytes();
        base64Images.add('data:image/png;base64,${base64Encode(bytes)}');
      }
      return base64Images;
    }

    return images.map((image) => image.path).toList();
  }
}
