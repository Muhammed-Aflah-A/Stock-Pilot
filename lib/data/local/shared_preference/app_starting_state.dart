import 'package:shared_preferences/shared_preferences.dart';

// Uses the `shared_preferences` package to check the completion status
class AppStartingState {
  // Key used to store onboarding completion status
  static final onboardingDone = 'onboarding_done';
  // Key used to store profile creation completion status
  static final profileDone = 'profile_done';
  // Marks onboarding as completed in local storage.
  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingDone, true);
  }

  // Marks profile creation as completed in local storage
  static Future<void> setProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(profileDone, true);
  }

  // Check the onboarding is done or not
  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingDone) ?? false;
  }

  // Check the profile creation is done or not
  static Future<bool> isProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(profileDone) ?? false;
  }
}
