import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
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
                    "lib/assets/images/onboarding2.png",
                    width: 500,
                    height: 500,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text("Never Run Out Again", style: TextStyles.onboardingHeading),
              SizedBox(height: 10),
              Text(
                "Get alerts for low-stock items and",
                style: TextStyles.onboardingMessage,
              ),
              Text(
                "restock at the right time",
                style: TextStyles.onboardingMessage,
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/onboarding_screen_3");
                },
                style: ButtonStyles.nextButton,
                child: Text("Next", style: TextStyles.nextButtonText),
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
