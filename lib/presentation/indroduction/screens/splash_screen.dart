import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/indroduction/view_model/splash_screen_provider.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/animated_text_widget.dart';
import 'package:stock_pilot/presentation/indroduction/widgets/hero_image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Run navigation logic after the first frame is built
    // This prevents context-related errors during widget initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashScreenProvider>().checkFlow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App primary splash background
      backgroundColor: ColourStyles.primaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // This widget is used to display the image on the splash screen
                HeroImageWidget(
                  heightFactor: 0.3,
                  imagePath: AppImages.appLogo,
                ),
                SizedBox(height: 20),
                // This widget is used to animate the text on the splash screen
                AnimatedTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
