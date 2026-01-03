import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

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
              AppnameWidget(),
              SizedBox(height: h * 0.05),
              HeroimageWidget(
                heightFactor: 0.5,
                imagePath: AppImages.onboardingScreen1,
              ),
              SizedBox(height: h * 0.1),
              Text("Track Your Stock Effortlessly", style: TextStyles.tagLine),
              SizedBox(height: h * 0.02),
              Text("Stay updated with real-time", style: TextStyles.caption),
              Text(
                "item counts and accurate stock levels",
                style: TextStyles.caption,
              ),
              SizedBox(height: h * 0.1),
              NextbuttonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onBoardingScreen_2);
                },
                text: "Next",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
