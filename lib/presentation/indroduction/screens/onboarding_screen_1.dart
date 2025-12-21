import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// First onboarding screen: shows branding, illustration, short copy,
// and a button to proceed to the next onboarding step.
// Keep UI simple and responsive using MediaQuery-based spacing.

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    //Calculating screens heigth
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Layered RichText: first layer provides an outlined/stroked
                  // style, second layer provides the filled text to create
                  // a combined visual effect for the app title.
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Stock", style: TextStyles.stroke),
                        WidgetSpan(child: SizedBox(width: h * 0.01)),
                        TextSpan(text: "Pilot", style: TextStyles.stroke),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Stock", style: TextStyles.stockText),
                        WidgetSpan(child: SizedBox(width: h * 0.01)),
                        TextSpan(text: "Pilot", style: TextStyles.pilotText),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.05),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.5,
                  // Illustration for the onboarding screen. Clipping and
                  // alignment control the visible portion and aspect.
                  child: Image.asset(
                    AppImages.onboardingScreen1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: h * 0.1),
              Text("Track Your Stock Effortlessly", style: TextStyles.tagLine),
              SizedBox(height: h * 0.02),
              // Short explanatory caption split across two lines for layout
              Text("Stay updated with real-time", style: TextStyles.caption),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.caption,
              ),
              SizedBox(height: h * 0.1),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next onboarding screen using named route
                  Navigator.pushNamed(context, AppRoutes.onBoardingScreen_2);
                },
                style: ButtonStyles.nextButton,
                child: Text("Next", style: TextStyles.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
