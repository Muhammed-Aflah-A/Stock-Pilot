import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/onboarding_screen_provider.dart';

// Button created to skip onboarding screens
class SkipButtonWidget extends StatelessWidget {
  const SkipButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        // Setting onboarding done
        await context.read<OnboardingScreenProvider>().setOnboardingDone();
        if (!context.mounted) return;
        // Navigating to profile creation page
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
