import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/presentation/Dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/profile_creation.dart';
import 'package:stock_pilot/presentation/indroductioon/viewmodel/profile_creation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveAdapters.register();
  await HiveService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(hiveService: HiveService()),
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
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // -------------------- (FADE) ---------------------
          case "/":
            return TransitionAnimations.fadeRoute(const SplashScreen());

          case "/onboarding_screen_1":
            return TransitionAnimations.fadeRoute(const OnboardingScreen1());

          case "/profile_creation":
            return TransitionAnimations.fadeRoute(const ProfileCreation());

          case "/dashboard":
            return TransitionAnimations.fadeRoute(const Dashboard());

          // -------------------- (SLIDE) --------------------
          case "/onboarding_screen_2":
            return TransitionAnimations.slideRoute(const OnboardingScreen2());

          case "/onboarding_screen_3":
            return TransitionAnimations.slideRoute(const OnboardingScreen3());
        }

        return null;
      },
    );
  }
}
