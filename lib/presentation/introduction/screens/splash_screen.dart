import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/introduction/view_model/splash_screen_provider.dart';
import 'package:stock_pilot/presentation/introduction/widgets/animated_text_widget.dart';
import 'package:stock_pilot/presentation/introduction/widgets/hero_image_widget.dart';

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
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroImageWidget(
                  heightFactor: 0.3,
                  imagePath: AppImages.appLogo,
                ),
                SizedBox(height: 20),
                AnimatedTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

