import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/widgets/backbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                heightFactor: 0.6,
                imagePath: AppImages.onboardingScreen3,
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
              BackbuttonWidget(),
              SizedBox(height: h * 0.03),
              NextbuttonWidget(
                onPressed: () async {
                  await AppStartingState.setOnboardingDone();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.profileCreation,
                    (route) => false,
                  );
                },
                text: "Get Started",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
