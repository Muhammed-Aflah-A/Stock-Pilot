import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      title: Center(child: Text("Choose option", style: TextStyles.heading_2)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera", style: TextStyles.primaryText),
            onTap: () async {
              final status = await context
                  .read<ProfileCreationProvider>()
                  .cameraPermission();
              if (status.isGranted) {
                context.read<ProfileCreationProvider>().openCamera();
              } else if (status.isPermanentlyDenied) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: ColourStyles.primaryColor,
                      title: Center(
                        child: Text(
                          "Permission Required",
                          style: TextStyles.heading_2,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Permission is permanently denied.",
                            style: TextStyles.primaryTextRed,
                          ),
                          Text(
                            "Please enable it from app settings.",
                            style: TextStyles.primaryTextRed,
                          ),
                        ],
                      ),
                      actions: [
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(
                                        child: Text(
                                          "Camera permission permanently denied",
                                        ),
                                      ),
                                      backgroundColor: ColourStyles.colorRed,
                                    ),
                                  );
                                },
                                style: ButtonStyles.dialogBackButton,
                                child: Text("Cancel"),
                              ),
                              SizedBox(height: h * 0.01),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await openAppSettings();
                                },
                                style: ButtonStyles.dialogNextButton,
                                child: Text("Open Settings"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text("Camera permission denied")),
                    backgroundColor: ColourStyles.colorRed,
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("Library"),
            onTap: () async {
              final status = await context
                  .read<ProfileCreationProvider>()
                  .libraryPermission();
              if (status.isGranted) {
                context.read<ProfileCreationProvider>().openLibrary();
              } else if (status.isPermanentlyDenied) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: ColourStyles.primaryColor,
                      title: Center(
                        child: Text(
                          "Permission Required",
                          style: TextStyles.heading_2,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Permission is permanently denied.",
                            style: TextStyles.primaryTextRed,
                          ),
                          Text(
                            "Please enable it from app settings.",
                            style: TextStyles.primaryTextRed,
                          ),
                        ],
                      ),
                      actions: [
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(
                                        child: Text(
                                          "Library permission permanently denied",
                                        ),
                                      ),
                                      backgroundColor: ColourStyles.colorRed,
                                    ),
                                  );
                                },
                                style: ButtonStyles.dialogBackButton,
                                child: Text("Cancel"),
                              ),
                              SizedBox(height: h * 0.01),
                              ElevatedButton(
                                onPressed: () {
                                  openAppSettings();
                                  Navigator.pop(context);
                                },
                                style: ButtonStyles.dialogNextButton,
                                child: Text("Open Settings"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text("Library permission denied")),
                    backgroundColor: ColourStyles.colorRed,
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
          SizedBox(height: h * 0.01),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyles.dialogBackButton,
            child: Text("Back", style: TextStyles.buttonText_2),
          ),
        ],
      ),
    );
  }
}
