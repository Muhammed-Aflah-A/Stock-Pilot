import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/onboarding_screen_provider.dart';
import 'package:stock_pilot/presentation/introduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/hero_image_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/skip_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/back_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/next_button_widget.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                      Visibility(
                        visible: false,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SkipButtonWidget(),
                        ),
                      ),
                      AppnameWidget(),
                      Spacer(flex: 3),
                      Flexible(
                        flex: 6,
                        child: HeroImageWidget(
                          heightFactor: 0.3,
                          imagePath: AppImages.onboardingScreen3,
                        ),
                      ),
                      Spacer(flex: 3),
                      Text(
                        "Smart Reports & Analytics",
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
                      Text("3/3", style: TextStyles.tagLineCaption(context)),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                BackbuttonWidget(),
                SizedBox(height: 12),
                NextbuttonWidget(
                  text: "Get Started",
                  onPressed: () async {
                    await context
                        .read<OnboardingScreenProvider>()
                        .setOnboardingDone();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.profileCreation,
                        (route) => false,
                      );
                    }
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

