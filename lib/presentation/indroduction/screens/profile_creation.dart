// Profile creation screen
// This screen collects personal details, shop details,
// and allows selecting a profile image using camera or gallery.

import 'dart:io'; // Used to handle file paths for images

import 'package:flutter/material.dart'; // Core Flutter UI widgets
import 'package:permission_handler/permission_handler.dart'; // Runtime permissions
import 'package:provider/provider.dart'; // State management (Provider)

import 'package:stock_pilot/core/assets/app_images.dart'; // App images
import 'package:stock_pilot/core/navigation/app_routes.dart'; // App routes
import 'package:stock_pilot/core/theme/button_styles.dart'; // Button styles
import 'package:stock_pilot/core/theme/colours_styles.dart'; // App colors
import 'package:stock_pilot/core/theme/text_styles.dart'; // Text styles

import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
// Stores onboarding/profile completion flags

import 'package:stock_pilot/data/models/user_profle_model.dart';
// User profile data model

import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
// Drawer state provider

import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
// Handles form state, permissions, and image picking

import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
// Loads and updates saved user profile

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    // Screen height for responsive spacing
    final h = MediaQuery.of(context).size.height;

    // Provider that holds form data and image path
    final profileForm = context.watch<ProfileCreationProvider>();

    // Drawer provider to set selected item after success
    final drawerProvider = context.watch<DrawerProvider>();

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true, // Prevent keyboard overlap
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.05),

              // Main heading
              Text("Get Started!", style: TextStyles.heading),

              // Subtitle
              Text(
                "Create a profile to manage inventory",
                style: TextStyles.caption_2,
              ),

              SizedBox(height: h * 0.02),

              // ================= PROFILE IMAGE =================
              Center(
                child: Stack(
                  children: [
                    // Shows selected image or default image
                    Consumer<ProfileCreationProvider>(
                      builder: (context, provider, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: ColourStyles.primaryColor_2,
                          backgroundImage:
                              (provider.profileImage != null &&
                                  File(provider.profileImage!).existsSync())
                              ? FileImage(File(provider.profileImage!))
                              : AssetImage(AppImages.profilePicture),
                        );
                      },
                    ),

                    // Edit icon on profile image
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ColourStyles.primaryColor_2,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColourStyles.primaryColor,
                            width: 3,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: ColourStyles.primaryColor,
                          ),
                          onPressed: () {
                            // Dialog to choose camera or gallery
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: ColourStyles.primaryColor,
                                  title: Center(
                                    child: Text(
                                      "Choose option",
                                      style: TextStyles.heading_2,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // CAMERA OPTION
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Camera"),
                                        onTap: () async {
                                          final status = await context
                                              .read<ProfileCreationProvider>()
                                              .cameraPermission();

                                          if (status.isGranted) {
                                            context
                                                .read<ProfileCreationProvider>()
                                                .openCamera();
                                          } else if (status
                                              .isPermanentlyDenied) {
                                            await openAppSettings();
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),

                                      // GALLERY OPTION
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Library"),
                                        onTap: () async {
                                          final status = await context
                                              .read<ProfileCreationProvider>()
                                              .libraryPermission();

                                          if (status.isGranted) {
                                            context
                                                .read<ProfileCreationProvider>()
                                                .openLibrary();
                                          } else if (status
                                              .isPermanentlyDenied) {
                                            await openAppSettings();
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.005),

              // ================= FORM SECTION =================
              // Form widget groups all input fields
              Form(
                key: profileForm.formKey,
                child: Column(
                  children: [
                    // FULL NAME FIELD
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Full Name"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.fullName = value!.trim();
                      },
                    ),

                    SizedBox(height: h * 0.02),

                    // PERSONAL PHONE NUMBER
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "Phone Number"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a phone number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.personalNumber = value!.trim();
                      },
                    ),

                    SizedBox(height: h * 0.02),

                    // SHOP NAME
                    TextFormField(
                      decoration: InputDecoration(labelText: "Shop Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter shop name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.shopName = value!.trim();
                      },
                    ),

                    SizedBox(height: h * 0.02),

                    // SHOP ADDRESS
                    TextFormField(
                      decoration: InputDecoration(labelText: "Shop Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter shop address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.shopAdress = value!.trim();
                      },
                    ),

                    SizedBox(height: h * 0.02),

                    // SHOP PHONE NUMBER
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Shop Phone Number",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter shop phone number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.shopNumber = value!.trim();
                      },
                    ),

                    SizedBox(height: h * 0.02),

                    // EMAIL FIELD
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter email";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profileForm.gmail = value!.trim();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.05),

              // ================= SUBMIT BUTTON =================
              Center(
                child: ElevatedButton(
                  style: ButtonStyles.nextButton,
                  child: Text("Create Profile"),
                  onPressed: () async {
                    if (profileForm.formKey.currentState!.validate()) {
                      profileForm.formKey.currentState!.save();

                      // Create user object from form data
                      final user = UserProfile(
                        profileImage: profileForm.profileImage,
                        fullName: profileForm.fullName,
                        personalNumber: profileForm.personalNumber,
                        shopName: profileForm.shopName,
                        shopAdress: profileForm.shopAdress,
                        shopNumber: profileForm.shopNumber,
                        gmail: profileForm.gmail,
                      );

                      // Save user to database
                      await profileForm.addUser(user);

                      // Reload profile
                      context.read<ProfilePageProvider>().loadUser();

                      // Mark profile as completed
                      await AppStartingState.setProfileDone();

                      // Select dashboard in drawer
                      drawerProvider.selectedDrawerItem(1);

                      // Navigate to dashboard
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.dashboard,
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
