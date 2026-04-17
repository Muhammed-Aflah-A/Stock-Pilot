import 'package:image_picker/image_picker.dart';

class ImageSelectorUtil {
  static final ImagePicker picker = ImagePicker();
  static Future<String?> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

  static Future<String?> openLibrary() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    return image?.path;
  }

  static Future<List<String>?> openLibraryMulti() async {
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (images.isEmpty) return null;
    return images.map((image) => image.path).toList();
  }
}

