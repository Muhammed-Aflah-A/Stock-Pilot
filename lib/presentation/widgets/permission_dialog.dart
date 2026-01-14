import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class PermissionDialog extends StatelessWidget {
  final dynamic provider;
  final int? index;
  const PermissionDialog({super.key, required this.provider, this.index});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
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
              final status = await provider.cameraPermission();
              if (status == PermissionStatus.granted) {
                if (index != null) {
                  await provider.openCamera(index!);
                } else {
                  await provider.openCamera();
                }
              } else if (status == PermissionStatus.permanentlyDenied) {
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
                              SizedBox(height: currentHeigth * 0.01),
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
              final status = await provider.libraryPermission();
              if (status == PermissionStatus.granted) {
                if (index != null) {
                  await provider.openLibrary(index!);
                } else {
                  await provider.openLibrary();
                }
              } else if (status == PermissionStatus.permanentlyDenied) {
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
                              SizedBox(height: currentHeigth * 0.01),
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
          SizedBox(height: currentHeigth * 0.01),
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
