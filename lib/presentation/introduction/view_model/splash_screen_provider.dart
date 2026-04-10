import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';

// Handles splash screen flow decision logic
class SplashScreenProvider with ChangeNotifier {
  // Duration the splash screen
  final splashDuration = Duration(seconds: 4);
  // Checks app starting state and navigates accordingly.
  Future<void> checkFlow(BuildContext context) async {
    // Check whether onboarding is completed
    final onboardingDone = await AppStartingState.isOnboardingDone();
    // Check whether profile setup is completed
    final profileDone = await AppStartingState.isProfileDone();
    // Ensure splash screen shows for a fixed duration
    await Future.delayed(splashDuration);
    // Prevent navigation if widget is already disposed
    if (!context.mounted) return;
    if (!onboardingDone) {
      // Navigate to onboarding flow
      navigate(context, AppRoutes.onBoardingScreen_1);
    } else if (!profileDone) {
      // Navigate to profile creation screen
      navigate(context, AppRoutes.profileCreation);
    } else {
      // Navigate to profile creation screen
      final drawerProvider = context.read<DrawerProvider>();
      drawerProvider.selectedDrawerItem(1);
      // Navigate to main dashboard
      navigate(context, AppRoutes.dashboard);
    }
  }

  // Clears navigation stack and moves to the given route.
  void navigate(BuildContext context, String page) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }
}
