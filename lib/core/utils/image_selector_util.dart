import 'package:image_picker/image_picker.dart';

// Utility class responsible for selecting images
class ImageSelectorUtil {
  // Single instance of ImagePicker used throughout the app.
  static final ImagePicker picker = ImagePicker();
  // Opens the device camera to capture an image.
  static Future<String?> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    // Return the image file path if an image was captured
    return image?.path;
  }

  // Opens the device gallery to select an image.
  static Future<String?> openLibrary() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      // Resize image to reduce memory usage
      maxWidth: 1024,
      maxHeight: 1024,
      // Compress image to reduce file size
      imageQuality: 85,
    );
    // Return the image path if selection was successful
    return image?.path;
  }

  // Opens the device gallery to select multiple images.
  static Future<List<String>?> openLibraryMulti() async {
    final List<XFile> images = await picker.pickMultiImage(
      // Resize image to reduce memory usage
      maxWidth: 1024,
      maxHeight: 1024,
      // Compress image to reduce file size
      imageQuality: 85,
    );
    if (images.isEmpty) return null;
    // Return all selected image paths
    return images.map((image) => image.path).toList();
  }
}
