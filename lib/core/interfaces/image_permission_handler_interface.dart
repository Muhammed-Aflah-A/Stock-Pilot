import 'package:flutter/material.dart';

// Interface that defines a contract for handling image permissions.
// Any class that implements this interface must provide
abstract class ImagePermissionHandler {
  Future<void> handleImagePermission({
    required BuildContext context,
    required bool isCamera,
    int? index,
  });
}
