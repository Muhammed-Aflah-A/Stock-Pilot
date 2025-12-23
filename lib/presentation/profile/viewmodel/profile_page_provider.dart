import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProfilePageProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;
  ProfilePageProvider({required this.hiveService}) {
    loadUser();
  }
  UserProfile? user;
  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

  Future<void> updateUser() async {
    await hiveService.updateUser(user!);
    notifyListeners();
  }

  Future<PermissionStatus> cameraPermission() async {
    // Request camera permission and return the resulting status.
    final status = await Permission.camera.request();
    return status;
  }

  Future<PermissionStatus> libraryPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // For Android 13+ use the photos permission
        status = await Permission.photos.request();
      } else {
        // For older Android versions use storage permission
        status = await Permission.storage.request();
      }
    } else {
      // iOS and other platforms should be handled as needed; default to denied
      status = PermissionStatus.denied;
    }
    return status;
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> openCamera() async {
    // Launch device camera and store selected image path
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      user?.profileImage = image.path;
      await hiveService.updateUser(user!);
      notifyListeners();
    }
  }

  Future<void> openLibrary() async {
    // Open gallery/library and store selected image path
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      user?.profileImage = image.path;
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
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'name',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.phone_android_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Phone number",
        subtitle: user!.personalNumber,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'personalNumber',
      ),
      PersonalInfo(
        leadingIcon: Icon(
          Icons.mail_outline,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Email",
        subtitle: user!.gmail,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
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
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'shop name',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.location_on_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Address",
        subtitle: user!.shopAdress,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'address',
      ),
      ShopInfo(
        leadingIcon: Icon(
          Icons.phone_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        title: "Shop Number",
        subtitle: user!.shopNumber,
        trailingIcon: Icon(
          Icons.edit_outlined,
          color: ColourStyles.primaryColor_2,
        ),
        feildtype: 'shopNumber',
      ),
    ];
  }

  TextInputType? getKeyboardType(String type) {
    switch (type.toLowerCase()) {
      case "name":
        return TextInputType.name;
      case "email":
        return TextInputType.emailAddress;
      case 'personalNumber':
        return TextInputType.phone;
      case 'shop name':
        return TextInputType.text;
      case 'shop address':
        return TextInputType.multiline;
      case 'shopNumber':
        return TextInputType.phone;
      default:
        return null;
    }
  }

  String? validate(String? value, String type) {
    switch (type.toLowerCase()) {
      case 'name':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter your full name";
        }
        if (RegExp(r'\d').hasMatch(value)) {
          return "Name cannot contain numbers";
        }
        if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
          return "Name cannot contain special characters";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Name cannot contain multiple spaces together";
        }
        if (value.length < 3) {
          return "Name must be at least 3 characters";
        }
        return null;
      case 'personalNumber':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a phone number";
        }
        if (!value.startsWith('+')) {
          return "Phone number must start with +";
        }
        if (RegExp(r'\s').hasMatch(value)) {
          return "Phone number must not contain spaces";
        }
        if (!RegExp(r'^\+\d+$').hasMatch(value)) {
          return "Only numbers are allowed after +";
        }
        if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
          return "Enter a valid international phone number";
        }
        return null;
      case 'email':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a email";
        }
        if (!RegExp(r'^[a-z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      case 'shop name':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter you shop name";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Shop name cannot contain multiple spaces together";
        }
        return null;
      case 'shop address':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter your shop address";
        }
        if (value.length < 10) {
          return "Shop address must be at least 10 characters";
        }
        if (RegExp(r'\s{2,}').hasMatch(value)) {
          return "Shop address cannot contain multiple spaces together";
        }
        return null;
      case 'shopNumber':
        value = value?.trim();
        if (value == null || value.isEmpty) {
          return "Please enter a phone number";
        }
        if (!value.startsWith('+')) {
          return "Phone number must start with +";
        }
        if (RegExp(r'\s').hasMatch(value)) {
          return "Phone number must not contain spaces";
        }
        if (!RegExp(r'^\+\d+$').hasMatch(value)) {
          return "Only numbers are allowed after +";
        }
        if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
          return "Enter a valid international phone number";
        }
        return null;
      default:
        return null;
    }
  }
}
