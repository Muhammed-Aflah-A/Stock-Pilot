import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/splash_screen_provider.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/animatedtext_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/heroimage_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashScreenProvider>().checkFlow(context);
    });
  }

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
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroimageWidget(
                          heightFactor: 0.3,
                          imagePath: AppImages.appLogo,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        AnimatedtextWidget(),
                      ],
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
