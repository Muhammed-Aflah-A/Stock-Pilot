import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';

// Splash screen shown at app start. Displays the app logo and a short
// animated tagline, then navigates to the onboarding flow after a delay.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Duration to wait on the splash screen before navigating onward
  static const _splashDuration = Duration(seconds: 4);
  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    final onboardingDone = await AppStartingState.isOnboardingDone();
    final profileDone = await AppStartingState.isProfileDone();
    // Wait for the splash duration then navigate to the onboarding
    await Future.delayed(_splashDuration);
    // guard against widget being disposed
    if (!mounted) return;
    //Checking the Screens once gone through or not
    if (!onboardingDone) {
      navigate(AppRoutes.onBoardingScreen_1);
    } else if (!profileDone) {
      navigate(AppRoutes.profileCreation);
    } else {
      context.read<DrawerProvider>().selectedDrawerItem(1);
      navigate(AppRoutes.dashboard);
    }
  }

  // Replace the current route stack with the onboarding route
  void navigate(String page) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.splashBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo centered and clipped to control visible area
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.65,
                  child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
                ),
              ),
              // Animated tagline using the app's quote text style
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Smart Stock, Smooth Business',
                    textStyle: TextStyles.splashQuote,
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                //Total repetation of animated app's quote
                totalRepeatCount: 1,
                //Pause duration between app's quote
                pause: Duration(seconds: 1),
                //Show the full text when the user taps on animated app's quote.
                displayFullTextOnTap: true,
                //Stop animated app's quote on tap
                stopPauseOnTap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
