import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProfileCreationProvider with ChangeNotifier {
  String? profileImage;
  final formKey = GlobalKey<FormState>();
  String? fullName;
  final shopNameFocus = FocusNode();
  String? shopName;
  final shopAdressFocus = FocusNode();
  String? shopAdress;
  final shopNumberFocus = FocusNode();
  String? shopNumber;
  final personalNumberFocus = FocusNode();
  String? personalNumber;
  final emailFocus = FocusNode();
  String? gmail;
  final HiveServiceLayer hiveService;
  final ImageSelectorUtil imageSelector;
  ProfileCreationProvider({
    required this.hiveService,
    required this.imageSelector,
  });
  Future<void> openCamera() async {
    final path = await imageSelector.openCamera();
    if (path != null) {
      profileImage = path;
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    final path = await imageSelector.openLibrary();
    if (path != null) {
      profileImage = path;
      notifyListeners();
    }
  }

  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }
}
