import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
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
import 'package:stock_pilot/presentation/profile/screens/profile_page.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter (local storage)
  await Hive.initFlutter();

  // Register all Hive type adapters used in the app
  HiveAdapters.register();

  // Initialize any Hive boxes or services (opens boxes, migrations, etc.)
  await HiveService.init();
  runApp(
    //Multiproviders are listed here
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(hiveService: HiveService()),
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
      //initial page is declared here
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Routes that use a fade transition animation
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

          // Routes that use a slide transition animation
          case AppRoutes.onBoardingScreen_2:
            return TransitionAnimations.slideRoute(const OnboardingScreen2());

          case AppRoutes.onBoardingScreen_3:
            return TransitionAnimations.slideRoute(const OnboardingScreen3());
        }
        return null;
      },
    );
  }
}
