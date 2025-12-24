// Core Flutter UI package
import 'package:flutter/material.dart';

// App images (onboarding illustrations, logos, etc.)
import 'package:stock_pilot/core/assets/app_images.dart';

// Centralized route names for navigation
import 'package:stock_pilot/core/navigation/app_routes.dart';

// Predefined button styles
import 'package:stock_pilot/core/theme/button_styles.dart';

// App color constants
import 'package:stock_pilot/core/theme/colours_styles.dart';

// App text style definitions
import 'package:stock_pilot/core/theme/text_styles.dart';

// Shared preference helper to store onboarding completion state
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';

/// OnboardingScreen3
/// This is the third and final onboarding screen.
/// It introduces reports & analytics and allows the user
/// to finish onboarding and start using the app.
class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    // Get device screen height for responsive spacing
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      // Background color for onboarding screen
      backgroundColor: ColourStyles.primaryColor,

      body: SafeArea(
        child: Center(
          child: Column(
            // Center all content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stack is used to layer two texts
              // to create stroke + filled brand text
              Stack(
                children: [
                  // Bottom layer: stroked text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Stock", style: TextStyles.stroke),
                        WidgetSpan(child: SizedBox(width: h * 0.01)),
                        TextSpan(text: "Pilot", style: TextStyles.stroke),
                      ],
                    ),
                  ),

                  // Top layer: filled text
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

              // Space below title
              SizedBox(height: h * 0.05),

              // Illustration image for onboarding screen 3
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.6,
                  child: Image.asset(
                    AppImages.onboardingScreen3,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Space below image
              SizedBox(height: h * 0.05),

              // Main heading text
              Text("Smart Reports & Analytics", style: TextStyles.tagLine),

              SizedBox(height: h * 0.02),

              // Description text
              Text("Stay updated with real-time", style: TextStyles.caption),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.caption,
              ),

              // Space before buttons
              SizedBox(height: h * 0.08),

              // Back button (returns to previous onboarding screen)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyles.backButton,
                child: Text("Back", style: TextStyles.buttonText_2),
              ),

              SizedBox(height: h * 0.03),

              // "Get Started" button
              ElevatedButton(
                onPressed: () async {
                  // Mark onboarding as completed in local storage
                  await AppStartingState.setOnboardingDone();

                  // Clear all previous screens and open profile creation screen
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
