import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/appname_widget.dart';
import 'package:stock_pilot/presentation/widgets/backbutton_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/heroimage_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
                            imagePath: AppImages.onboardingScreen2,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          Text(
                            "Never Run Out Again",
                            style: TextStyles.tagLine(context),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          Text(
                            "Get alerts for low-stock items and restock at the right time",
                            style: TextStyles.tagLineCaption(context),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.01),
                          const Spacer(),
                          const BackbuttonWidget(),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          NextbuttonWidget(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.onBoardingScreen_3,
                              );
                            },
                            text: "Next",
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
