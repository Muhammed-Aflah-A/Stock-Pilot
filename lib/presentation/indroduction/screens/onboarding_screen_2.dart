import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/hero_image_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/skip_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/back_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/next_button_widget.dart';

// Second onboarding screen.
class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Button to skip onboarding pages
                        Align(
                          alignment: Alignment.topRight,
                          child: SkipButtonWidget(),
                        ),
                        // App name as heading
                        AppnameWidget(),
                        SizedBox(height: 30),
                        // Illustration image goes here
                        HeroImageWidget(
                          heightFactor: 0.3,
                          imagePath: AppImages.onboardingScreen2,
                        ),
                        SizedBox(height: 30),
                        // Main headline
                        Text(
                          "Never Run Out Again",
                          style: TextStyles.tagLine(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        // Supporting description
                        Text(
                          "Get alerts for low-stock items and restock at the right time",
                          style: TextStyles.tagLineCaption(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        // Progress indicator
                        Text("2/3", style: TextStyles.tagLineCaption(context)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Navigate back to previous onbvoarding screen
                BackbuttonWidget(),
                SizedBox(height: 12),
                // Navigate to next onboarding screen
                NextbuttonWidget(
                  text: "Next",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.onBoardingScreen_3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
