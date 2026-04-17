import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/profile_creation_provider.dart';

class CreateProfileButtonWidget extends StatelessWidget {
  const CreateProfileButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          context.read<ProfileCreationProvider>().createProfile(context),
      style: ButtonStyles.nextButton(context),
      child: Text("Create Profile", style: TextStyles.buttonTextWhite(context)),
    );
  }
}

