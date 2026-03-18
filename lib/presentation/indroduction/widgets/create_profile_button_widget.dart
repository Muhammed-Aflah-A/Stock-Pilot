import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/view_model/profile_creation_provider.dart';

// Button widget responsible for triggering the profile creation process.
class CreateProfileButtonWidget extends StatelessWidget {
  const CreateProfileButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Call the provider method that handles the profile creation workflow (validation, saving, navigation, etc.)
      onPressed: () =>
          context.read<ProfileCreationProvider>().createProfile(context),
      style: ButtonStyles.nextButton(context),
      // Button label
      child: Text("Create Profile", style: TextStyles.buttonTextWhite(context)),
    );
  }
}
