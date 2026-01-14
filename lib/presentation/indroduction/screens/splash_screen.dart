import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/local/shared_preference/app_starting_state.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/animatedtext_widget.dart';
import 'package:stock_pilot/presentation/widgets/heroimage_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    final onboardingDone = await AppStartingState.isOnboardingDone();
    final profileDone = await AppStartingState.isProfileDone();
    await Future.delayed(_splashDuration);
    if (!mounted) return;

    if (!onboardingDone) {
      navigate(AppRoutes.onBoardingScreen_1);
    } else if (!profileDone) {
      navigate(AppRoutes.profileCreation);
    } else {
      await context.read<ProfilePageProvider>().loadUser();
      await context.read<ProductProvider>().loadProducts();
      context.read<DrawerProvider>().selectedDrawerItem(1);
      navigate(AppRoutes.dashboard);
    }
  }

  void navigate(String page) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColourStyles.splashBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroimageWidget(heightFactor: 1, imagePath: AppImages.appLogo),
              SizedBox(height: currentHeight * 0.01),
              AnimatedtextWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
