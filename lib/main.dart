// Flutter material package (basic UI widgets)
import 'package:flutter/material.dart';

// Hive packages for local storage
import 'package:hive_flutter/adapters.dart';

// Provider package for state management
import 'package:provider/provider.dart';

// App navigation and animations
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';

// Hive setup files
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';

// Dashboard screen and providers
import 'package:stock_pilot/presentation/dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';

// Introduction / onboarding screens
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/indroduction/screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/indroduction/screens/profile_creation.dart';

// Providers for profile creation and profile page
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/profile/screens/profile_page.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

/// Entry point of the application
void main() async {
  // Ensures Flutter engine is initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register all Hive adapters (models)
  HiveAdapters.register();

  // Initialize Hive boxes / services
  await HiveService.init();

  // Start the app with providers
  runApp(
    MultiProvider(
      providers: [
        // Provider for profile creation screen
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(
            hiveService: HiveService(),
          ),
        ),

        // Provider for drawer state
        ChangeNotifierProvider(create: (_) => DrawerProvider()),

        // Provider for dashboard logic
        ChangeNotifierProvider(create: (_) => DashboardProvider()),

        // Provider for profile page data
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(
            hiveService: HiveService(),
          ),
        ),
      ],

      // Root widget of the app
      child: StockPilot(),
    ),
  );
}

/// Root widget of the application
class StockPilot extends StatelessWidget {
  const StockPilot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the debug banner
      debugShowCheckedModeBanner: false,

      // App title
      title: "StockPilot",

      // First screen that opens when app starts
      initialRoute: AppRoutes.splashScreen,

      // Handle navigation with custom animations
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Splash screen route
          case AppRoutes.splashScreen:
            return TransitionAnimations.fadeRoute(
              const SplashScreen(),
            );

          // First onboarding screen
          case AppRoutes.onBoardingScreen_1:
            return TransitionAnimations.fadeRoute(
              const OnboardingScreen1(),
            );

          // Profile creation screen
          case AppRoutes.profileCreation:
            return TransitionAnimations.fadeRoute(
              const ProfileCreation(),
            );

          // Dashboard screen
          case AppRoutes.dashboard:
            return TransitionAnimations.fadeRoute(
              const Dashboard(),
            );

          // Profile page screen
          case AppRoutes.profilePage:
            return TransitionAnimations.fadeRoute(
              const ProfilePage(),
            );

          // Second onboarding screen (slide animation)
          case AppRoutes.onBoardingScreen_2:
            return TransitionAnimations.slideRoute(
              const OnboardingScreen2(),
            );

          // Third onboarding screen (slide animation)
          case AppRoutes.onBoardingScreen_3:
            return TransitionAnimations.slideRoute(
              const OnboardingScreen3(),
            );
        }

        // If route is not found, return null
        return null;
      },
    );
  }
}
