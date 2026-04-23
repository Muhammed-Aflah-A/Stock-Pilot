import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/onboarding_screen_provider.dart';

class SkipButtonWidget extends StatelessWidget {
  const SkipButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await context.read<OnboardingScreenProvider>().setOnboardingDone();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profileCreation,
          (route) => false,
        );
      },
      style: ButtonStyles.skipButton(context),
      child: Text("Skip"),
    );
  }
}
