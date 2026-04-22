import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/introduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/hero_image_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/skip_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/next_button_widget.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            imagePath: AppImages.onboardingScreen1,
                          ),
                        ),
                        Spacer(flex: 3),
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
                        Spacer(flex: 1),
                        Text("1/3", style: TextStyles.tagLineCaption(context)),
                        Spacer(flex: 1),
                      ],
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
        ),
      ),
    );
  }
}

