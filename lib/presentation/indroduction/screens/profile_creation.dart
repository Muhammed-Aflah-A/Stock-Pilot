// Profile creation screen: collects user details and an optional profile image.
// Includes permission handling for camera and gallery and validates form fields.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

/// Screen that displays a form for creating a user profile.
/// Uses `ProfileCreationProvider` for state and image handling.
class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    //Store the current BuildContext so you can use it later safely.
    //Some widgets (like ScaffoldMessenger, showSnackBar, showDialog) need a valid context.
    // final scaffoldContext = context;
    //Calculating screen heigth
    final h = MediaQuery.of(context).size.height;
    final profileForm = context.watch<ProfileCreationProvider>();
    final drawerProvider = context.watch<DrawerProvider>();
    // Main scaffold for the profile creation flow
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.03),
              Text("Get Started!", style: TextStyles.heading),
              Text(
                "Create a profile to manage inventory",
                style: TextStyles.caption_2,
              ),
              SizedBox(height: h * 0.02),
              // Profile image with an edit button to choose camera/library
              Center(
                child: Stack(
                  children: [
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
                    // Edit button positioned over the avatar
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
                            // Show dialog to choose image source (camera or gallery)
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
                                      // Camera option
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text(
                                          "Camera",
                                          style: TextStyles.primaryText,
                                        ),
                                        onTap: () async {
                                          //Calling function for asking permission
                                          final status = await context
                                              .read<ProfileCreationProvider>()
                                              .cameraPermission();
                                          if (status.isGranted) {
                                            //Calling function for opening camera
                                            context
                                                .read<ProfileCreationProvider>()
                                                .openCamera();
                                          }
                                          //If permenantly permission denied
                                          else if (status.isPermanentlyDenied) {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                //Dialog box for opening settings
                                                return AlertDialog(
                                                  backgroundColor:
                                                      ColourStyles.primaryColor,
                                                  title: Center(
                                                    child: Text(
                                                      "Permission Required",
                                                      style:
                                                          TextStyles.heading_2,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Permission is permanently denied.",
                                                        style: TextStyles
                                                            .primaryTextRed,
                                                      ),
                                                      Text(
                                                        "Please enable it from app settings.",
                                                        style: TextStyles
                                                            .primaryTextRed,
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          //Cancel button of dialog box
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Center(
                                                                    child: Text(
                                                                      "Camera permission permanently denied",
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      ColourStyles
                                                                          .colorRed,
                                                                ),
                                                              );
                                                            },
                                                            style: ButtonStyles
                                                                .dialogBackButton,
                                                            child: Text(
                                                              "Cancel",
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          //Button for opening app settings
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              await openAppSettings();
                                                            },
                                                            style: ButtonStyles
                                                                .dialogNextButton,
                                                            child: Text(
                                                              "Open Settings",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          //If camera permission denied
                                          else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    "Camera permission denied",
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColourStyles.colorRed,
                                              ),
                                            );
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                      // Gallery/library option
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Library"),
                                        onTap: () async {
                                          //Calling function for asking permission
                                          final status = await context
                                              .read<ProfileCreationProvider>()
                                              .libraryPermission();
                                          if (status.isGranted) {
                                            //Calling function for opening library
                                            context
                                                .read<ProfileCreationProvider>()
                                                .openLibrary();
                                          }
                                          //If permission permenently denied
                                          else if (status.isPermanentlyDenied) {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                //Dialog box for opening settings
                                                return AlertDialog(
                                                  backgroundColor:
                                                      ColourStyles.primaryColor,
                                                  title: Center(
                                                    child: Text(
                                                      "Permission Required",
                                                      style:
                                                          TextStyles.heading_2,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Permission is permanently denied.",
                                                        style: TextStyles
                                                            .primaryTextRed,
                                                      ),
                                                      Text(
                                                        "Please enable it from app settings.",
                                                        style: TextStyles
                                                            .primaryTextRed,
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          //Cancel utton for dilog box
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Center(
                                                                    child: Text(
                                                                      "Library permission permanently denied",
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      ColourStyles
                                                                          .colorRed,
                                                                ),
                                                              );
                                                            },
                                                            style: ButtonStyles
                                                                .dialogBackButton,
                                                            child: Text(
                                                              "Cancel",
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          //Button for opening app settings
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              openAppSettings();
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            style: ButtonStyles
                                                                .dialogNextButton,
                                                            child: Text(
                                                              "Open Settings",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          //If permission got denied
                                          else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    "Library permission denied",
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColourStyles.colorRed,
                                              ),
                                            );
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(height: h * 0.01),
                                      // Close dialog button
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyles.dialogBackButton,
                                        child: Text(
                                          "Back",
                                          style: TextStyles.buttonText_2,
                                        ),
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
              SizedBox(height: h * 0.01),
              // Form collecting name, shop details, phone and email
              Form(
                key: profileForm.formKey,
                child: Column(
                  children: [
                    // Full name field with validation
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        value = value?.trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        if (value.length < 3) {
                          return "Name must be at least 3 characters";
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
                        value = value.replaceAll("  ", " ");
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.fullName = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.shopNameFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    // Shop name field
                    TextFormField(
                      focusNode: profileForm.shopNameFocus,
                      decoration: InputDecoration(
                        labelText: "Shop Name",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        value = value?.trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter you shop name";
                        }
                        if (RegExp(r'\s{2,}').hasMatch(value)) {
                          return "Shop name cannot contain multiple spaces together";
                        }
                        value = value.replaceAll("  ", " ");
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.shopName = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.shopAdressFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    // Shop address field
                    TextFormField(
                      focusNode: profileForm.shopAdressFocus,
                      decoration: InputDecoration(
                        labelText: "Shop Address",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
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
                        value = value.replaceAll("  ", " ");
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.shopAdress = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.phoneNumberFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    // Phone number field (expects international format starting with +)
                    TextFormField(
                      focusNode: profileForm.phoneNumberFocus,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
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
                        value = value.replaceAll(" ", "");
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.phoneNumber = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.emailFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    // Email field with a basic regex validator
                    TextFormField(
                      focusNode: profileForm.emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.primaryColor_2,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        value = value?.replaceAll(" ", "");
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a email";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.gmail = newValue;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.05),
              Center(
                child: Column(
                  children: [
                    // Submit button: validates, saves user and navigates to dashboard
                    ElevatedButton(
                      onPressed: () async {
                        if (profileForm.formKey.currentState!.validate()) {
                          profileForm.formKey.currentState!.save();
                          //A object containing all the form data
                          final user = UserProfile(
                            profileImage: profileForm.profileImage,
                            fullName: profileForm.fullName,
                            shopName: profileForm.shopName,
                            shopAdress: profileForm.shopAdress,
                            gmail: profileForm.gmail,
                            phoneNumber: profileForm.phoneNumber,
                          );
                          //Passing data to the provider
                          await profileForm.addUser(user);
                          //Loading data from data base
                          context.read<ProfilePageProvider>().loadUser();
                          //Finishing profile creation
                          await AppStartingState.setProfileDone();
                          //Setting selected drawer menu
                          drawerProvider.selectedDrawerItem(1);
                          profileForm.formKey.currentState!.reset();
                          //navigating and removing all old screen
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.dashboard,
                            (route) => false,
                          );
                        }
                      },
                      style: ButtonStyles.nextButton,
                      child: Text(
                        "Create Profile",
                        style: TextStyles.buttonText,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Text("Manage your inventory", style: TextStyles.caption_3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
