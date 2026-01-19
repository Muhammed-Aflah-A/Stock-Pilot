import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/widgets/backbutton_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.08,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppnameWidget(),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          HeroimageWidget(
                            heightFactor: 0.3,
                            imagePath: AppImages.onboardingScreen3,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          Text(
                            "Smart Reports & Analytics",
                            style: TextStyles.tagLine(context),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          Text(
                            "Stay updated with real-time item counts and accurate stock levels",
                            style: TextStyles.tagLineCaption(context),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.01),
                          const Spacer(),
                          const BackbuttonWidget(),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          NextbuttonWidget(
                            onPressed: () async {
                              await AppStartingState.setOnboardingDone();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.profileCreation,
                                  (route) => false,
                                );
                              }
                            },
                            text: "Get Started",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
