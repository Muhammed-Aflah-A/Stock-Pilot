import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 4);
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(_splashDuration);
    Navigator.pushReplacementNamed(context, '/onboarding_screen_1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.splashBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              //----------------------------- (LOGO) -------------------------------------
              Image.asset(
                "lib/assets/images/logo.png",
                width: 400,
                height: 400,
              ),
              //----------------------------- (LOGO Quote) --------------------------------
              Positioned(
                top: 310,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Smart Stock, Smooth Business',
                      textStyle: TextStyles.logoQuote,
                      speed: Duration(milliseconds: 100),
                    ),
                    // TypewriterAnimatedText(
                    //   'Track Smarter, Sell Faster',
                    //   textStyle: TextStyles.logoQuote,
                    //   speed: Duration(milliseconds: 50),
                    // ),
                    // TypewriterAnimatedText(
                    //   'Inventory Clear. Decisions Easy',
                    //   textStyle: TextStyles.logoQuote,
                    //   speed: Duration(milliseconds: 50),
                    // ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
