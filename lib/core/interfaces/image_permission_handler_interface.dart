import 'package:flutter/material.dart';

abstract class ImagePermissionHandler {
  Future<void> handleImagePermission({
    required BuildContext context,
    required bool isCamera,
    int? index,
  });

  void removeImage({int? index});
}
