import 'package:shared_preferences/shared_preferences.dart';

class AppStartingState {
  static const _onboardingDone = 'onboarding_done';
  static const _profileDone = 'profile_done';
  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDone, true);
  }

  static Future<void> setProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileDone, true);
  }

  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingDone) ?? false;
  }

  static Future<bool> isProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileDone) ?? false;
  }
}
