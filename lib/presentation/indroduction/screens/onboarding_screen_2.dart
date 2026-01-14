import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/widgets/backbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: currentHeigth * 0.05),
              AppnameWidget(),
              SizedBox(height: currentHeigth * 0.05),
              HeroimageWidget(
                heightFactor: 1,
                imagePath: AppImages.onboardingScreen2,
              ),
              SizedBox(height: currentHeigth * 0.05),
              Text("Never Run Out Again", style: TextStyles.tagLine),
              SizedBox(height: currentHeigth * 0.02),
              Text(
                "Get alerts for low-stock items and",
                style: TextStyles.caption,
              ),
              Text("restock at the right time", style: TextStyles.caption),
              SizedBox(height: currentHeigth * 0.05),
              BackbuttonWidget(),
              SizedBox(height: currentHeigth * 0.02),
              NextbuttonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onBoardingScreen_3);
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
