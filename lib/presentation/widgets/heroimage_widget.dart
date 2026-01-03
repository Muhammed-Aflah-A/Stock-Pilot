import 'package:flutter/material.dart';

class HeroimageWidget extends StatelessWidget {
  final double heightFactor;
  final String imagePath;
  const HeroimageWidget({
    super.key,
    required this.heightFactor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        heightFactor: heightFactor,
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
