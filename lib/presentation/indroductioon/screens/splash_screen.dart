import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Splash screen shown at app start. Displays the app logo and a short
// animated tagline, then navigates to the onboarding flow after a delay.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 4);
  // Duration to wait on the splash screen before navigating onward
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    // Wait for the splash duration then navigate to the onboarding
    await Future.delayed(_splashDuration);
    if (!mounted) return; // guard against widget being disposed

    // Replace the current route stack with the onboarding route
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/onboarding_screen_1',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.7,
                  // App logo centered and clipped to control visible area
                  child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: h * 0.005),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Smart Stock, Smooth Business',
                    // Animated tagline using the app's quote text style
                    textStyle: TextStyles.quote,
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
