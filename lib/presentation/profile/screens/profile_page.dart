import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBar(
        backgroundColor: ColourStyles.primaryColor,
        toolbarHeight: 100,
        title: Text("Profile", style: TextStyles.heading_2),
      ),
      drawer: Drawer(
        backgroundColor: ColourStyles.primaryColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: ColourStyles.primaryColor),
              accountName: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.fullName}",
                    style: TextStyles.primaryText,
                  );
                },
              ),
              accountEmail: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.gmail}",
                    style: TextStyles.primaryText,
                  );
                },
              ),
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
                          provider.selectedDrawerItem(index);
                          Navigator.pop(context);
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
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
                                              .read<ProfilePageProvider>()
                                              .cameraPermission();
                                          if (status.isGranted) {
                                            //Calling function for opening camera
                                            context
                                                .read<ProfilePageProvider>()
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
                                              .read<ProfilePageProvider>()
                                              .libraryPermission();
                                          if (status.isGranted) {
                                            //Calling function for opening library
                                            context
                                                .read<ProfilePageProvider>()
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),
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
                            trailing: IconButton(
                              onPressed: () {
                                final formkey = GlobalKey<FormState>();
                                final controller = TextEditingController(
                                  text: item.subtitle,
                                );
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
                  Text("Shop Information", style: TextStyles.heading_3),
                  SizedBox(height: h * 0.01),
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
                            trailing: IconButton(
                              onPressed: () {
                                final formkey = GlobalKey<FormState>();
                                final controller = TextEditingController(
                                  text: item.subtitle,
                                );
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
