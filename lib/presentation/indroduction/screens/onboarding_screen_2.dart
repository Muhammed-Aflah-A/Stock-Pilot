// Core Flutter UI library
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

/// OnboardingScreen2
/// This is the second onboarding screen.
/// It explains low-stock alerts and restocking.
/// The screen provides:
/// - App title
/// - Illustration
/// - Short description
/// - Back and Next navigation buttons
class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    // Get device screen height for responsive spacing
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      // Background color for onboarding
      backgroundColor: ColourStyles.primaryColor,

      body: SafeArea(
        child: Center(
          child: Column(
            // Center content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stack is used to layer two texts for stroke + fill effect
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

              // Illustration image for onboarding screen 2
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.6,
                  child: Image.asset(
                    AppImages.onboardingScreen2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Space below image
              SizedBox(height: h * 0.05),

              // Main heading text
              Text("Never Run Out Again", style: TextStyles.tagLine),

              SizedBox(height: h * 0.02),

              // Description text
              Text(
                "Get alerts for low-stock items and",
                style: TextStyles.caption,
              ),
              Text("restock at the right time", style: TextStyles.caption),

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

              // Next button (moves to onboarding screen 3)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onBoardingScreen_3);
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
