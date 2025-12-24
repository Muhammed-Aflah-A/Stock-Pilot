// Core Flutter UI library
import 'package:flutter/material.dart';

// App image paths (logo, onboarding images, etc.)
import 'package:stock_pilot/core/assets/app_images.dart';

// Centralized app route names
import 'package:stock_pilot/core/navigation/app_routes.dart';

// Button style definitions
import 'package:stock_pilot/core/theme/button_styles.dart';

// App color constants
import 'package:stock_pilot/core/theme/colours_styles.dart';

// App text styles
import 'package:stock_pilot/core/theme/text_styles.dart';

/// OnboardingScreen1
/// This is the first onboarding screen shown after the splash screen.
/// It displays:
/// - App title (with styled text)
/// - An illustration image
/// - A short description
/// - A "Next" button to move to the next onboarding screen
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // Get device screen height to make UI responsive
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      // Background color of onboarding screen
      backgroundColor: ColourStyles.primaryColor,

      body: SafeArea(
        child: Center(
          child: Column(
            // Center all content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stack is used to place two texts on top of each other
              Stack(
                children: [
                  // First text layer (stroke / outline style)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Stock", style: TextStyles.stroke),
                        // Space between words
                        WidgetSpan(child: SizedBox(width: h * 0.01)),
                        TextSpan(text: "Pilot", style: TextStyles.stroke),
                      ],
                    ),
                  ),

                  // Second text layer (filled text)
                  // This sits on top of the stroked text
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

              // Space below app title
              SizedBox(height: h * 0.05),

              // Onboarding illustration image
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.5,
                  child: Image.asset(
                    AppImages.onboardingScreen1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Space below image
              SizedBox(height: h * 0.1),

              // Main tagline text
              Text("Track Your Stock Effortlessly", style: TextStyles.tagLine),

              SizedBox(height: h * 0.02),

              // Description text (split into two lines)
              Text("Stay updated with real-time", style: TextStyles.caption),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.caption,
              ),

              // Space before button
              SizedBox(height: h * 0.1),

              // "Next" button
              ElevatedButton(
                onPressed: () {
                  // Navigate to onboarding screen 2
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
