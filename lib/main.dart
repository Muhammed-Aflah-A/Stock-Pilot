import 'package:flutter/material.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/Indroductioon/Screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroductioon/screens/onboarding_screen_3.dart';

void main() {
  runApp(StockPilot());
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
            return _fadeRoute(const SplashScreen());

          case "/onboarding_screen_1":
            return _fadeRoute(const OnboardingScreen1());

          // -------------------- (SLIDE) --------------------
          case "/onboarding_screen_2":
            return _slideRoute(const OnboardingScreen2());

          case "/onboarding_screen_3":
            return _slideRoute(const OnboardingScreen3());
        }

        return null;
      },
    );
  }
}
//------------------------------ (FADE Animation Code)------------------------
PageRouteBuilder _fadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
//------------------------------ (SLIDE Animation Code)------------------------
PageRouteBuilder _slideRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1, 0), // from right
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(position: slide, child: child);
    },
  );
}
