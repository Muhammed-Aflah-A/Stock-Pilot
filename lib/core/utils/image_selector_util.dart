import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageSelectorUtil {
  final ImagePicker _picker = ImagePicker();

  Future<String?> openCamera() async {
    if (kIsWeb) {
      return null;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

  Future<String?> openLibrary() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: kIsWeb ? 1024 : null,
      maxHeight: kIsWeb ? 1024 : null,
      imageQuality: kIsWeb ? 85 : null,
    );
    return image?.path;
  }
}
