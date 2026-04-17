import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/introduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/hero_image_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/skip_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/back_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/next_button_widget.dart';

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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SkipButtonWidget(),
                      ),
                      AppnameWidget(),
                      Spacer(flex: 3),
                      Flexible(
                        flex: 6,
                        child: HeroImageWidget(
                          heightFactor: 0.3,
                          imagePath: AppImages.onboardingScreen2,
                        ),
                      ),
                      Spacer(flex: 3),
                      Text(
                        "Never Run Out Again",
                        style: TextStyles.tagLine(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Get alerts for low-stock items and restock at the right time",
                        style: TextStyles.tagLineCaption(context),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 1),
                      Text("2/3", style: TextStyles.tagLineCaption(context)),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                BackbuttonWidget(),
                SizedBox(height: 12),
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

