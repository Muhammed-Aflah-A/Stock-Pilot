import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset(
                    AppImages.onboardingScreen2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              Text("Never Run Out Again", style: TextStyles.tagLine),
              SizedBox(height: h * 0.02),
              Text(
                "Get alerts for low-stock items and",
                style: TextStyles.caption,
              ),
              Text("restock at the right time", style: TextStyles.caption),
              SizedBox(height: h * 0.08),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyles.backButton,
                child: Text("Back", style: TextStyles.buttonText_2),
              ),
              SizedBox(height: h * 0.03),
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
