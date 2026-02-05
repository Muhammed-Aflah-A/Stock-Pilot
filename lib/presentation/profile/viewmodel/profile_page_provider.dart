import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class ProfilePageProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  final ImageSelectorUtil imageSelector;
  ProfilePageProvider({
    required this.hiveService,
    required this.imageSelector,
  }) {
    loadUser();
  }
  UserProfile? user;
  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

  Future<void> updateUser() async {
    await hiveService.updateUser(user!);
    loadUser();
  }

  Future<void> openCamera() async {
    final path = await imageSelector.openCamera();
    if (path != null) {
      user?.profileImage = path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    final path = await imageSelector.openLibrary();
    if (path != null) {
      user?.profileImage = path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  List<PersonalInfo> get personalInfo {
    return [
      PersonalInfo(
        leadingIcon: Icon(
          Icons.person_2_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Full Name",
        subtitle: user!.fullName,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'name',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.phone_android_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Phone number",
        subtitle: user!.personalNumber,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'personal number',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.mail_outline,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Email",
        subtitle: user!.gmail,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'email',
      ),
    ];
  }

  List<ShopInfo> get shopInfo {
    return [
      ShopInfo(
        leadingIcon: Icon(
          Icons.store_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Name",
        subtitle: user!.shopName,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'shop name',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.location_on_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Address",
        subtitle: user!.shopAdress,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'address',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.phone_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Number",
        subtitle: user!.shopNumber,
        trailingIcon: Icon(Icons.mode_edit_outlined, color: ColourStyles.primaryColor_2),
        feildtype: 'shop number',
      ),
    ];
  }
}
