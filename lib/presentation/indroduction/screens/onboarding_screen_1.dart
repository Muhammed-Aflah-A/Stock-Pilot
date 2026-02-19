import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppnameWidget(),
                      SizedBox(height: 30),
                      HeroimageWidget(
                        heightFactor: 0.3,
                        imagePath: AppImages.onboardingScreen1,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Track Your Stock Effortlessly",
                        style: TextStyles.tagLine(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Stay updated with real-time item counts and accurate stock levels",
                        style: TextStyles.tagLineCaption(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text("1/3", style: TextStyles.tagLineCaption(context)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              NextbuttonWidget(
                text: "Next",
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onBoardingScreen_2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
