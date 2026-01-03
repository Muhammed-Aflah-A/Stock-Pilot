import 'dart:io';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<File?> productImages = List.filled(4, null);
}
