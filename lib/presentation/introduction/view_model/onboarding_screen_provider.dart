import 'package:flutter/material.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';

class OnboardingScreenProvider with ChangeNotifier {
  Future<void> setOnboardingDone() async {
    await AppStartingState.setOnboardingDone();
  }
}

