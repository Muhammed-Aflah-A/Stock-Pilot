import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/createprofile_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/profile_creation_form_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfileCreation extends StatelessWidget {
  const ProfileCreation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Get Started!",
                        style: TextStyles.indroductionHeading(context),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Create a profile to manage inventory",
                        style: TextStyles.indroductionCaption(context),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Center(
                        child: Consumer<ProfileCreationProvider>(
                          builder: (context, provider, _) {
                            return UserAvatarEditWidget(
                              imagePath: provider.profileImage,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => PermissionDialog(
                                    provider: context
                                        .read<ProfileCreationProvider>(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      ProfileCreationFormWidget(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              CreateProfileButtonWidget(),
              SizedBox(height: 8),
              Text(
                "Manage your inventory",
                style: TextStyles.buttonCaption(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
