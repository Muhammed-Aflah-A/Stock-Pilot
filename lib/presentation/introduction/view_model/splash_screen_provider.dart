import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';

class SplashScreenProvider with ChangeNotifier {
  final splashDuration = Duration(seconds: 4);
  Future<void> checkFlow(BuildContext context) async {
    final onboardingDone = await AppStartingState.isOnboardingDone();
    final profileDone = await AppStartingState.isProfileDone();
    await Future.delayed(splashDuration);
    if (!context.mounted) return;
    if (!onboardingDone) {
      navigate(context, AppRoutes.onBoardingScreen_1);
    } else if (!profileDone) {
      navigate(context, AppRoutes.profileCreation);
    } else {
      final drawerProvider = context.read<DrawerProvider>();
      drawerProvider.selectedDrawerItem(1);
      navigate(context, AppRoutes.dashboard);
    }
  }

  void navigate(BuildContext context, String page) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }
}

