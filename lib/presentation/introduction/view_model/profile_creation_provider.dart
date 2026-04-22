import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/utils/crop_image_util.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class ProfileCreationProvider
    with ChangeNotifier
    implements ImagePermissionHandler {
  String? profileImage;
  String? fullName;
  String? personalNumber;
  String? shopName;
  String? shopAddress;
  String? shopNumber;
  String? gmail;
  final formKey = GlobalKey<FormState>();
  final personalNumberFocus = FocusNode();
  final shopNameFocus = FocusNode();
  final shopAddressFocus = FocusNode();
  final shopNumberFocus = FocusNode();
  final emailFocus = FocusNode();
  final HiveServiceLayer hiveService;
  ProfileCreationProvider({required this.hiveService});
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

  Future<void> openCamera(BuildContext context) async {
    final path = await ImageSelectorUtil.openCamera();
    if (path == null) return;
    if (!context.mounted) return;
    final croppedPath = await ImageCropUtil.cropImageToPath(path, context: context);
    if (croppedPath == null) return;
    final savedPath = await ImageUtil.saveImage(croppedPath);
    profileImage = savedPath;
    notifyListeners();
  }

  @override
  void removeImage({int? index}) {
    profileImage = null;
    notifyListeners();
  }

  Future<void> openLibrary(BuildContext context) async {
    final path = await ImageSelectorUtil.openLibrary();
    if (path == null) return;
    if (!context.mounted) return;
    final croppedPath = await ImageCropUtil.cropImageToPath(path, context: context);
    if (croppedPath == null) return;
    final savedPath = await ImageUtil.saveImage(croppedPath);
    profileImage = savedPath;
    notifyListeners();
  }

  void setFullName(String? value) {
    fullName = value?.trim();
  }

  void setPersonalNumber(String? value) {
    personalNumber = value?.trim();
  }

  void setShopName(String? value) {
    shopName = value?.trim();
  }

  void setShopAddress(String? value) {
    shopAddress = value?.trim();
  }

  void setShopNumber(String? value) {
    shopNumber = value?.trim();
  }

  void setGmail(String? value) {
    gmail = value?.trim();
  }

  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }

  Future<void> createProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    final user = UserProfile(
      profileImage: profileImage,
      fullName: fullName,
      personalNumber: personalNumber,
      shopName: shopName,
      shopAddress: shopAddress,
      shopNumber: shopNumber,
      gmail: gmail,
    );
    try {
      await addUser(user);
    } catch (e) {
      if (!context.mounted) return;
      SnackbarUtil.showSnackBar(context, "Failed to save profile: $e", true);
      return;
    }
    formKey.currentState?.reset();
    profileImage = null;
    notifyListeners();
    if (!context.mounted) return;
    context.read<ProfilePageProvider>().loadUser();
    await AppStartingState.setProfileDone();
    if (!context.mounted) return;
    context.read<DrawerProvider>().selectedDrawerItem(1);
    SnackbarUtil.showSnackBar(context, "Profile created successfully", false);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
  }

  @override
  void dispose() {
    personalNumberFocus.dispose();
    shopNameFocus.dispose();
    shopAddressFocus.dispose();
    shopNumberFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }
}

