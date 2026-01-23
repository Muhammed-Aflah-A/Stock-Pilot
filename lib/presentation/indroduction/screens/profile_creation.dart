import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/createprofile_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/profile_creation_form_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.08,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text(
                          "Get Started!",
                          style: TextStyles.indroductionHeading(context),
                        ),
                        Text(
                          "Create a profile to manage inventory",
                          style: TextStyles.indroductionCaption(context),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.04),
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
                                        provider: context
                                            .read<ProfileCreationProvider>(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.04),
                        const ProfileCreationFormWidget(),
                        SizedBox(height: constraints.maxHeight * 0.01),
                        const Spacer(),
                        Center(
                          child: Column(
                            children: [
                              const CreateProfileButtonWidget(),
                              SizedBox(height: constraints.maxHeight * 0.01),
                              Text(
                                "Manage your inventory",
                                style: TextStyles.buttonCaption(context),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
