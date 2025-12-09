import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
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
              SizedBox(height: 30),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.6,
                  child: Image.asset(
                    "lib/assets/images/onboarding3.png",
                    width: 500,
                    height: 500,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Smart Reports & Analytics",
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
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyles.nextButton,
                child: Text("Get Started", style: TextStyles.nextButtonText),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyles.backButton,
                child: Text("Back", style: TextStyles.backButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
