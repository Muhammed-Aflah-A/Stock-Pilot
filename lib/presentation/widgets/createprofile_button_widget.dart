import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class CreateProfileButtonWidget extends StatelessWidget {
  const CreateProfileButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileForm = context.watch<ProfileCreationProvider>();
    final drawerProvider = context.watch<DrawerProvider>();
    return ElevatedButton(
      onPressed: () async {
        if (profileForm.formKey.currentState!.validate()) {
          profileForm.formKey.currentState!.save();
          final user = UserProfile(
            profileImage: profileForm.profileImage,
            fullName: profileForm.fullName,
            personalNumber: profileForm.personalNumber,
            shopName: profileForm.shopName,
            shopAdress: profileForm.shopAdress,
            shopNumber: profileForm.shopNumber,
            gmail: profileForm.gmail,
          );
          await profileForm.addUser(user);
          context.read<ProfilePageProvider>().loadUser();
          await AppStartingState.setProfileDone();
          drawerProvider.selectedDrawerItem(1);
          profileForm.formKey.currentState!.reset();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        }
      },
      style: ButtonStyles.nextButton,
      child: Text("Create Profile", style: TextStyles.buttonText),
    );
  }
}
