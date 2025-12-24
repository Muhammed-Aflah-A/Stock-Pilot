// Profile page screen
// Displays user profile details, profile image editing,
// personal information, shop information, and navigation drawer.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// App assets and theme
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Providers
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Screen height and width for responsive sizing
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      // Screen background color
      backgroundColor: ColourStyles.primaryColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: ColourStyles.primaryColor,
        toolbarHeight: 100,
        title: Text("Profile", style: TextStyles.heading_2),
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        backgroundColor: ColourStyles.primaryColor,
        child: Column(
          children: [
            // Drawer header showing user info
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: ColourStyles.primaryColor),

              // User full name
              accountName: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.fullName}",
                    style: TextStyles.primaryText,
                  );
                },
              ),

              // User email
              accountEmail: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.gmail}",
                    style: TextStyles.primaryText,
                  );
                },
              ),

              // User profile picture
              currentAccountPicture: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: ColourStyles.primaryColor_2,
                    backgroundImage:
                        (provider.user?.profileImage != null &&
                            File(provider.user!.profileImage!).existsSync())
                        ? FileImage(File(provider.user!.profileImage!))
                        : AssetImage(AppImages.profilePicture),
                  );
                },
              ),
            ),

            // Drawer menu items
            Expanded(
              child: Consumer<DrawerProvider>(
                builder: (context, provider, child) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: h * 0.01),
                    itemCount: provider.drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.drawerItems[index];

                      return ListTile(
                        selected: provider.selectedIndex == index,
                        selectedTileColor: ColourStyles.baseBackgroundColor,
                        tileColor: ColourStyles.primaryColor,
                        leading: Image.asset(item.icon!, height: 35, width: 35),
                        title: Text(
                          item.title!,
                          style: TextStyles.primaryText_2,
                        ),
                        onTap: () {
                          // Update selected drawer item
                          provider.selectedDrawerItem(index);

                          // Close drawer
                          Navigator.pop(context);

                          // Navigate to selected screen
                          Navigator.pushNamed(context, "${item.navigation}");
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PROFILE IMAGE =================
              Center(
                child: Stack(
                  children: [
                    // Profile image display
                    Consumer<ProfilePageProvider>(
                      builder: (context, provider, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: ColourStyles.primaryColor_2,
                          backgroundImage:
                              (provider.user?.profileImage != null &&
                                  File(
                                    provider.user!.profileImage!,
                                  ).existsSync())
                              ? FileImage(File(provider.user!.profileImage!))
                              : AssetImage(AppImages.profilePicture),
                        );
                      },
                    ),

                    // Edit button on profile image
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
                            // Dialog to choose Camera or Gallery
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
                                      // ================= CAMERA OPTION =================
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text(
                                          "Camera",
                                          style: TextStyles.primaryText,
                                        ),
                                        onTap: () async {
                                          // Request camera permission
                                          final status = await context
                                              .read<ProfilePageProvider>()
                                              .cameraPermission();

                                          if (status.isGranted) {
                                            // Open camera
                                            context
                                                .read<ProfilePageProvider>()
                                                .openCamera();
                                          }
                                          // Permanently denied → show settings dialog
                                          else if (status.isPermanentlyDenied) {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
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
                                                          // Cancel button
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
                                                          // Open settings button
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
                                          // Permission denied normally
                                          else {
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

                                      // ================= GALLERY OPTION =================
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Library"),
                                        onTap: () async {
                                          // Request gallery permission
                                          final status = await context
                                              .read<ProfilePageProvider>()
                                              .libraryPermission();

                                          if (status.isGranted) {
                                            // Open gallery
                                            context
                                                .read<ProfilePageProvider>()
                                                .openLibrary();
                                          }
                                          // Permanently denied → show settings dialog
                                          else if (status.isPermanentlyDenied) {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
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
                                                          // Cancel button
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
                                                          // Open settings button
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
                                          // Permission denied normally
                                          else {
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

              SizedBox(height: h * 0.05),

              // ================= PERSONAL INFORMATION =================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),

                  // List of personal information items
                  Consumer<ProfilePageProvider>(
                    builder: (context, provider, child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.personalInfo.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: h * 0.01),
                        itemBuilder: (context, index) {
                          final item = provider.personalInfo[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: ColourStyles.baseBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: item.leadingIcon,
                            ),
                            title: Text(item.title!),
                            subtitle: Text(item.subtitle!),

                            // Edit button for personal info
                            trailing: IconButton(
                              onPressed: () {
                                // Create form key and controller for dialog
                                final formkey = GlobalKey<FormState>();
                                final controller = TextEditingController(
                                  text: item.subtitle,
                                );

                                // Show edit dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          ColourStyles.primaryColor,
                                      title: Center(
                                        child: Text(
                                          "Edit ${item.title}",
                                          style: TextStyles.heading_2,
                                        ),
                                      ),
                                      content: Form(
                                        key: formkey,
                                        child: TextFormField(
                                          controller: controller,
                                          keyboardType: provider
                                              .getKeyboardType(item.feildtype!),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    ColourStyles.primaryColor_2,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    ColourStyles.primaryColor_2,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          validator: (value) => provider
                                              .validate(value, item.feildtype!),
                                          onSaved: (newValue) {
                                            // Update correct field based on type
                                            switch (item.feildtype) {
                                              case 'name':
                                                provider.user!.fullName =
                                                    newValue!.trim();
                                                break;
                                              case 'personalNumber':
                                                provider.user!.personalNumber =
                                                    newValue!.trim();
                                                break;
                                              case 'email':
                                                provider.user!.gmail = newValue!
                                                    .trim();
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyles
                                                  .dialogBackButton_2,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("cancel"),
                                            ),
                                            SizedBox(width: w * 0.02),
                                            ElevatedButton(
                                              style: ButtonStyles
                                                  .dialogNextButton_2,
                                              onPressed: () async {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  formkey.currentState!.save();
                                                  await provider.updateUser();
                                                  formkey.currentState!.reset();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("save"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: item.trailingIcon!,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: h * 0.01),

                  // ================= SHOP INFORMATION =================
                  Text("Shop Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),

                  // List of shop information items
                  Consumer<ProfilePageProvider>(
                    builder: (context, provider, child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.shopInfo.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: h * 0.01),
                        itemBuilder: (context, index) {
                          final item = provider.shopInfo[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: ColourStyles.baseBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: item.leadingIcon,
                            ),
                            title: Text(item.title!),
                            subtitle: Text(item.subtitle!),

                            // Edit button for shop info
                            trailing: IconButton(
                              onPressed: () {
                                final formkey = GlobalKey<FormState>();
                                final controller = TextEditingController(
                                  text: item.subtitle,
                                );

                                // Show edit dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          ColourStyles.primaryColor,
                                      title: Center(
                                        child: Text(
                                          "Edit ${item.title}",
                                          style: TextStyles.heading_2,
                                        ),
                                      ),
                                      content: Form(
                                        key: formkey,
                                        child: TextFormField(
                                          controller: controller,
                                          keyboardType: provider
                                              .getKeyboardType(item.feildtype!),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    ColourStyles.primaryColor_2,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    ColourStyles.primaryColor_2,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          validator: (value) => provider
                                              .validate(value, item.feildtype!),
                                          onSaved: (newValue) {
                                            // Update correct shop field
                                            switch (item.feildtype) {
                                              case 'shop name':
                                                provider.user!.shopName =
                                                    newValue!.trim();
                                                break;
                                              case 'address':
                                                provider.user!.shopAdress =
                                                    newValue!.trim();
                                                break;
                                              case 'shopNumber':
                                                provider.user!.shopNumber =
                                                    newValue!.trim();
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyles
                                                  .dialogBackButton_2,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("cancel"),
                                            ),
                                            SizedBox(width: w * 0.02),
                                            ElevatedButton(
                                              style: ButtonStyles
                                                  .dialogNextButton_2,
                                              onPressed: () async {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  formkey.currentState!.save();
                                                  await provider.updateUser();
                                                  formkey.currentState!.reset();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("save"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: item.trailingIcon!,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
