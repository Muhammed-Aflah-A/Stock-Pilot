// Package used to show animated text (typewriter effect)
import 'package:animated_text_kit/animated_text_kit.dart';

// Core Flutter UI package
import 'package:flutter/material.dart';

// Provider package for state management
import 'package:provider/provider.dart';

// App image constants (logo, icons, etc.)
import 'package:stock_pilot/core/assets/app_images.dart';

// Centralized route names
import 'package:stock_pilot/core/navigation/app_routes.dart';

// App color definitions
import 'package:stock_pilot/core/theme/colours_styles.dart';

// App text styles
import 'package:stock_pilot/core/theme/text_styles.dart';

// Shared preference helper to check app starting state
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';

// Provider used to control drawer state
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';

/// SplashScreen
/// This screen is shown when the app starts.
/// It displays the app logo and an animated tagline.
/// After a delay, it decides which screen to navigate to
/// based on onboarding and profile completion status.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // How long the splash screen should stay visible
  static const _splashDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    // Start checking which screen to open next
    _checkFlow();
  }

  /// Checks whether onboarding and profile creation
  /// are already completed, then navigates accordingly
  Future<void> _checkFlow() async {
    // Check if onboarding screens were completed
    final onboardingDone = await AppStartingState.isOnboardingDone();

    // Check if profile creation is completed
    final profileDone = await AppStartingState.isProfileDone();

    // Wait for splash screen duration
    await Future.delayed(_splashDuration);

    // Safety check: make sure widget is still in the widget tree
    if (!mounted) return;

    // Decide which screen to open next
    if (!onboardingDone) {
      // User has not completed onboarding
      navigate(AppRoutes.onBoardingScreen_1);
    } else if (!profileDone) {
      // User completed onboarding but not profile creation
      navigate(AppRoutes.profileCreation);
    } else {
      // User completed everything → go to dashboard
      context.read<DrawerProvider>().selectedDrawerItem(1);
      navigate(AppRoutes.dashboard);
    }
  }

  /// Navigates to a new page and removes all previous routes
  /// (prevents user from going back to splash screen)
  void navigate(String page) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color for splash screen
      backgroundColor: ColourStyles.splashBackgroundColor,

      body: SafeArea(
        child: Center(
          child: Column(
            // Center content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              // ClipRect + Align are used to control visible height
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.65,
                  child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
                ),
              ),

              // Animated tagline below the logo
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Smart Stock, Smooth Business',
                    textStyle: TextStyles.splashQuote,
                    speed: Duration(milliseconds: 100),
                  ),
                ],

                // Animation plays only once
                totalRepeatCount: 1,

                // Pause after animation finishes
                pause: Duration(seconds: 1),

                // Show full text if user taps
                displayFullTextOnTap: true,

                // Stop animation when user taps
                stopPauseOnTap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
