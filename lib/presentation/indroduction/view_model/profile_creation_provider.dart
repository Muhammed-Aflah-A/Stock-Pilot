import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/interfaces/image_permission_handler_interface.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/permission_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

// Provider responsible for handling profile creation logic,
class ProfileCreationProvider
    with ChangeNotifier
    implements ImagePermissionHandler {
  // Path to the selected profile image
  String? profileImage;
  // Variable used to store data
  String? fullName;
  String? personalNumber;
  String? shopName;
  String? shopAddress;
  String? shopNumber;
  String? gmail;
  // Global key used to manage and validate the form
  final formKey = GlobalKey<FormState>();
  // Focus node for moving focus from one form to another
  final personalNumberFocus = FocusNode();
  final shopNameFocus = FocusNode();
  final shopAddressFocus = FocusNode();
  final shopNumberFocus = FocusNode();
  final emailFocus = FocusNode();
  final HiveServiceLayer hiveService;
  ProfileCreationProvider({required this.hiveService});
  // Handles permission flow for selecting profile image
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

  // Opens camera and stores the selected image path
  Future<void> openCamera() async {
    final path = await ImageSelectorUtil.openCamera();
    if (path != null) {
      final savedPath = await ImageUtil.saveImage(File(path));
      profileImage = savedPath;
      notifyListeners();
    }
  }

  // Opens gallery and stores the selected image path
  Future<void> openLibrary() async {
    final path = await ImageSelectorUtil.openLibrary();
    if (path != null) {
      final savedPath = await ImageUtil.saveImage(File(path));
      profileImage = savedPath;
      notifyListeners();
    }
  }

  // Setter for full name
  void setFullName(String? value) {
    fullName = value?.trim();
  }

  // Setter for personal number
  void setPersonalNumber(String? value) {
    personalNumber = value?.trim();
  }

  // Setter for shop name
  void setShopName(String? value) {
    shopName = value?.trim();
  }

  // Setter for shop address
  void setShopAddress(String? value) {
    shopAddress = value?.trim();
  }

  // Setter for shop number
  void setShopNumber(String? value) {
    shopNumber = value?.trim();
  }

  // Setter for gmail
  void setGmail(String? value) {
    gmail = value?.trim();
  }

  // Saves the created user profile into Hive database
  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }

  // Main workflow for creating the user profile
  Future<void> createProfile(BuildContext context) async {
    // Validate form inputs
    if (!formKey.currentState!.validate()) return;
    // Save form field values
    formKey.currentState!.save();
    // Create user model from collected form data
    final user = UserProfile(
      profileImage: profileImage,
      fullName: fullName,
      personalNumber: personalNumber,
      shopName: shopName,
      shopAddress: shopAddress,
      shopNumber: shopNumber,
      gmail: gmail,
    );
    // Save user to Hive database
    await addUser(user);
    if (!context.mounted) return;
    // Load saved user data into profile page
    context.read<ProfilePageProvider>().loadUser();
    // Mark profile creation as completed
    await AppStartingState.setProfileDone();
    if (!context.mounted) return;
    // Update selected drawer item
    context.read<DrawerProvider>().selectedDrawerItem(1);
    // Show success message
    SnackbarUtil.showSnackBar(context, "Profile created successfully", false);
    // Navigate to dashboard and remove previous routes
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
  }
}
