import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.onboardingBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Stoke",
                          style: TextStyles.logoNameStroke,
                        ),
                        WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: "Pilot",
                          style: TextStyles.logoNameStroke,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Stoke",
                          style: TextStyles.logoNameStock,
                        ),
                        WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: "Pilot",
                          style: TextStyles.logoNamePilot,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.6,
                  child: Image.asset(
                    "lib/assets/images/onboarding1.png",
                    width: 500,
                    height: 500,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Track Your Stock Effortlessly",
                style: TextStyles.onboardingHeading,
              ),
              SizedBox(height: 10),
              Text(
                "Stay updated with real-time",
                style: TextStyles.onboardingMessage,
              ),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.onboardingMessage,
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/onboarding_screen_2");
                },
                style: ButtonStyles.nextButton,
                child: Text("Next", style: TextStyles.nextButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
