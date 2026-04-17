import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final String? title;

  const ImagePreviewScreen({super.key, required this.imagePath, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title ?? "Image Preview",
          style: const TextStyle(
            color: ColourStyles.primaryColor,
            fontFamily: "ManRope",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ColourStyles.primaryColor_2,
        iconTheme: const IconThemeData(color: ColourStyles.primaryColor),
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                color: ColourStyles.primaryColor,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

