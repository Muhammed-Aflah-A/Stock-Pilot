import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/createprofile_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';
import 'package:stock_pilot/presentation/widgets/profile_creation_form_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.05),
              Text("Get Started!", style: TextStyles.heading),
              Text(
                "Create a profile to manage inventory",
                style: TextStyles.caption_2,
              ),
              SizedBox(height: h * 0.02),
              Center(
                child: Consumer<ProfileCreationProvider>(
                  builder: (context, provider, child) {
                    return UserAvatarEditWidget(
                      imagePath: provider.profileImage,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PermissionDialog(
                              provider: context.read<ProfileCreationProvider>(),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: h * 0.02),
              ProfileCreationFormWidget(),
              SizedBox(height: h * 0.02),
              Center(
                child: Column(
                  children: [
                    CreateProfileButtonWidget(),
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
