import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';

// Third onboarding screen: introduces reports & analytics and provides
// the final step to start the app (navigates to profile creation).
// Uses the same responsive layout patterns as other onboarding screens.

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                  // Layered title: stroke layer below and filled text above
                  // to create the brand wordmark visual.
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
                  heightFactor: 0.6,
                  // Illustration for the final onboarding screen. Clipped to
                  // keep the composition consistent across device sizes.
                  child: Image.asset(
                    AppImages.onboardingScreen3,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              Text("Smart Reports & Analytics", style: TextStyles.tagLine),
              SizedBox(height: h * 0.02),
              Text("Stay updated with real-time", style: TextStyles.caption),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.caption,
              ),
              SizedBox(height: h * 0.08),
              ElevatedButton(
                onPressed: () {
                  // Return to the previous onboarding screen
                  Navigator.pop(context);
                },
                style: ButtonStyles.backButton,
                child: Text("Back", style: TextStyles.buttonText_2),
              ),
              SizedBox(height: h * 0.03),
              ElevatedButton(
                onPressed: () async {
                  // Finish onboarding:
                  await AppStartingState.setOnboardingDone();
                  // Clear navigation stack and open the profile creation flow.
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.profileCreation,
                    (route) => false,
                  );
                },
                style: ButtonStyles.nextButton,
                child: Text("Get Started", style: TextStyles.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
