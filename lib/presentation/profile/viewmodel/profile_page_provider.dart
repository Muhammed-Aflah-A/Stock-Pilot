import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/utils/crop_image_util.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/data/models/user_profile_details_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class ProfilePageProvider
    with ChangeNotifier
    implements ImagePermissionHandler {
  final HiveServiceLayer hiveService;
  ProfilePageProvider({required this.hiveService}) {
    loadUser();
  }
  UserProfile? user;
  @override
  Future<void> handleImagePermission({
    required BuildContext context,
    required bool isCamera,
    int? index,
  }) async {
    await PermissionUtil.handleImagePermission(
      context: context,
      provider: this,
      isCamera: isCamera,
      index: index,
    );
  }

  Future<void> loadUser() async {
    user = await hiveService.getUser();
    notifyListeners();
  }

  Future<void> openCamera(BuildContext context) async {
    final path = await ImageSelectorUtil.openCamera();
    if (path == null) return;
    if (!context.mounted) return;
    final croppedPath = await ImageCropUtil.cropImageToPath(
      path,
      context: context,
    );
    if (croppedPath == null) return;
    final savedPath = await ImageUtil.saveImage(croppedPath);
    await updateProfileImage(savedPath);
    notifyListeners();
  }

  @override
  void removeImage({int? index}) {
    if (user != null) {
      user!.profileImage = null;
      updateUser();
    }
  }

  Future<void> openLibrary(BuildContext context) async {
    final path = await ImageSelectorUtil.openLibrary();
    if (path == null) return;
    if (!context.mounted) return;
    final croppedPath = await ImageCropUtil.cropImageToPath(
      path,
      context: context,
    );
    if (croppedPath == null) return;
    final savedPath = await ImageUtil.saveImage(croppedPath);
    await updateProfileImage(savedPath);
  }

  List<UserProfileDetailsModel> get personalInfo {
    return [
      UserProfileDetailsModel(
        leadingIcon: Icons.person_2_outlined,
        title: "Full Name",
        subtitle: user?.fullName ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'name',
      ),
      UserProfileDetailsModel(
        leadingIcon: Icons.mail_outline,
        title: "Email",
        subtitle: user?.gmail ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'email',
      ),
      UserProfileDetailsModel(
        leadingIcon: Icons.phone_android_outlined,
        title: "Phone number",
        subtitle: user?.personalNumber ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'personal number',
      ),
    ];
  }

  List<UserProfileDetailsModel> get shopInfo {
    return [
      UserProfileDetailsModel(
        leadingIcon: Icons.store_outlined,
        title: "Shop Name",
        subtitle: user?.shopName ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'shop name',
      ),
      UserProfileDetailsModel(
        leadingIcon: Icons.location_on_outlined,
        title: "Shop Address",
        subtitle: user?.shopAddress ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'address',
      ),
      UserProfileDetailsModel(
        leadingIcon: Icons.phone_outlined,
        title: "Shop Number",
        subtitle: user?.shopNumber ?? "",
        trailingIcon: Icons.mode_edit_outlined,
        feildtype: 'shop number',
      ),
    ];
  }

  Future<void> updateProfile(String feildType, String value) async {
    switch (feildType) {
      case 'name':
        user?.fullName = value;
        break;
      case 'email':
        user?.gmail = value;
        break;
      case 'personal number':
        user?.personalNumber = value;
        break;
      case 'shop name':
        user?.shopName = value;
        break;
      case 'address':
        user?.shopAddress = value;
        break;
      case 'shop number':
        user?.shopNumber = value;
        break;
    }
    await updateUser();
  }

  Future<void> updateProfileImage(String? path) async {
    if (path == null) return;
    user?.profileImage = path;
    await hiveService.updateUser(user!);
    notifyListeners();
  }

  Future<void> updateUser() async {
    if (user == null) return;
    await hiveService.updateUser(user!);
    notifyListeners();
  }
}
