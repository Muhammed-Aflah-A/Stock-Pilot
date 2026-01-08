import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/core/service/image_permission.dart';
import 'package:stock_pilot/core/service/image_selector.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/presentation/dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/indroduction/screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/indroduction/screens/profile_creation.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/product/screens/product_adding_page_1.dart';
import 'package:stock_pilot/presentation/product/screens/product_adding_page_2.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/profile/screens/profile_page.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/product/screens/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveAdapters.register();
  await HiveService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(
            hiveService: HiveService(),
            imagePermission: ImagePermission(),
            imageSelector: ImageSelector(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(
            hiveService: HiveService(),
            imagePermission: ImagePermission(),
            imageSelector: ImageSelector(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            imagePermission: ImagePermission(),
            imageSelector: ImageSelector(),
          ),
        ),
      ],
      child: StockPilot(),
    ),
  );
}

class StockPilot extends StatelessWidget {
  const StockPilot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "StockPilot",
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splashScreen:
            return TransitionAnimations.fadeRoute(const SplashScreen());
          case AppRoutes.onBoardingScreen_1:
            return TransitionAnimations.fadeRoute(const OnboardingScreen1());
          case AppRoutes.profileCreation:
            return TransitionAnimations.fadeRoute(const ProfileCreation());
          case AppRoutes.dashboard:
            return TransitionAnimations.fadeRoute(const Dashboard());
          case AppRoutes.profilePage:
            return TransitionAnimations.fadeRoute(const ProfilePage());
          case AppRoutes.productListPage:
            return TransitionAnimations.fadeRoute(const ProductListPage());
          case AppRoutes.productAddingPage1:
            return TransitionAnimations.fadeRoute(const ProductAddingPage1());

          case AppRoutes.onBoardingScreen_2:
            return TransitionAnimations.slideRoute(const OnboardingScreen2());
          case AppRoutes.onBoardingScreen_3:
            return TransitionAnimations.slideRoute(const OnboardingScreen3());
          case AppRoutes.productAddingPage2:
            return TransitionAnimations.slideRoute(const ProductAddingPage2());
        }
        return null;
      },
    );
  }
}
