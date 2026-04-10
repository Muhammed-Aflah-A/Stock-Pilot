import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/introduction/widgets/create_profile_button_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/profile_creation_form_widget.dart';
import 'package:stock_pilot/presentation/widgets/permission_dialog_widget.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_edit_widget.dart';

// Screen responsible for creating a new user profile.
class ProfileCreation extends StatelessWidget {
  const ProfileCreation({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive spacing
    final size = MediaQuery.of(context).size;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // Allows UI to adjust when keyboard appears
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
                  // Allows keyboard to dismiss when user scrolls
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      // Screen heading
                      Text(
                        "Get Started!",
                        style: TextStyles.introductionHeading(context),
                      ),
                      SizedBox(height: 6),
                      // Short description below heading
                      Text(
                        "Create a profile to manage inventory",
                        style: TextStyles.introductionCaption(context),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Center(
                        child: Consumer<ProfileCreationProvider>(
                          builder: (context, provider, _) {
                            // Profile image selector
                            return UserAvatarEditWidget(
                              imagePath: provider.profileImage,
                              onPressed: () {
                                // Dialog used to choose camera or gallery
                                  showDialog(
                                    context: context,
                                    builder: (_) => PermissionDialog(
                                      provider: provider,
                                      showRemoveOption: provider.profileImage != null,
                                    ),
                                  );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      // Form widget containing profile input fields
                      ProfileCreationFormWidget(),
                    ],
                  ),
                ),
              ),
              if (!isKeyboardVisible) ...[
                const SizedBox(height: 12),
                // Button that triggers profile creation
                const CreateProfileButtonWidget(),
                const SizedBox(height: 8),
                // Small caption under the button
                Text(
                  "Manage your inventory",
                  style: TextStyles.buttonCaption(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
