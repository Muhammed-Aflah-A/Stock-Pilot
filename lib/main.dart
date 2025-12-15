import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/presentation/Dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/Dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/Dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/profile_creation.dart';
import 'package:stock_pilot/presentation/indroductioon/viewmodel/profile_creation_provider.dart';

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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DrawerProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
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
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Routes that use a fade transition animation
          case "/":
            return TransitionAnimations.fadeRoute(const SplashScreen());

          case "/onboarding_screen_1":
            return TransitionAnimations.fadeRoute(const OnboardingScreen1());

          case "/profile_creation":
            return TransitionAnimations.fadeRoute(const ProfileCreation());

          case "/dashboard":
            return TransitionAnimations.fadeRoute(const Dashboard());
          // Routes that use a slide transition animation
          case "/onboarding_screen_2":
            return TransitionAnimations.slideRoute(const OnboardingScreen2());

          case "/onboarding_screen_3":
            return TransitionAnimations.slideRoute(const OnboardingScreen3());

          case "":
            return TransitionAnimations.slideRoute(const OnboardingScreen3());
        }

        return null;
      },
    );
  }
}
