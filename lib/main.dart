import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/core/utils/image_selector_util.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/brand/screens/brand_list_page.dart';
import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/category/screens/category_list_page.dart';
import 'package:stock_pilot/presentation/category/viewmodel/category_provider.dart';
import 'package:stock_pilot/presentation/dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/indroduction/screens/splash_screen.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/indroduction/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/indroduction/screens/profile_creation.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/splash_screen_provider.dart';
import 'package:stock_pilot/presentation/low%20stock/screens/lowstock_list_page.dart';
import 'package:stock_pilot/presentation/out%20of%20stock/screens/out_of_stock_list_page.dart';
import 'package:stock_pilot/presentation/product/screens/product_adding_page_1.dart';
import 'package:stock_pilot/presentation/product/screens/product_adding_page_2.dart';
import 'package:stock_pilot/presentation/product/screens/product_details_page.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/profile/screens/profile_page.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/product/screens/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Hive.initFlutter();
  HiveAdapters.register();
  await HiveService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(
            hiveService: HiveService(),
            imageSelector: ImageSelectorUtil(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(
            hiveService: HiveService(),
            imageSelector: ImageSelectorUtil(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(
          create: (_) => BrandProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProxyProvider2<
          CategoryProvider,
          BrandProvider,
          ProductProvider
        >(
          create: (context) => ProductProvider(
            imageSelector: ImageSelectorUtil(),
            hiveService: HiveService(),
          ),
          update: (context, categoryProvider, brandProvider, productProvider) {
            productProvider!.categories(categoryProvider.categories);
            productProvider.brands(brandProvider.brands);
            return productProvider;
          },
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
          //Fade animation
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
            final args = settings.arguments as Map<String, dynamic>?;
            return TransitionAnimations.fadeRoute(
              ProductAddingPage1(
                product: args?['product'] as ProductModel?,
                productIndex: args?['productIndex'] as int?,
              ),
              settings: settings,
            );
          case AppRoutes.category:
            return TransitionAnimations.fadeRoute(const CategoryListPage());
          case AppRoutes.brand:
            return TransitionAnimations.fadeRoute(const BrandListPage());
          case AppRoutes.lowStockPage:
            return TransitionAnimations.fadeRoute(const LowstockListPage());
          case AppRoutes.outOfStockPage:
            return TransitionAnimations.fadeRoute(const OutOfStockListPage());

          //Slide animation
          case AppRoutes.onBoardingScreen_2:
            return TransitionAnimations.slideRoute(const OnboardingScreen2());
          case AppRoutes.onBoardingScreen_3:
            return TransitionAnimations.slideRoute(const OnboardingScreen3());
          case AppRoutes.productAddingPage2:
            final args = settings.arguments as Map<String, dynamic>?;
            return TransitionAnimations.slideRoute(
              ProductAddingPage2(
                product: args?['product'] as ProductModel?,
                productIndex: args?['productIndex'] as int?,
              ),
              settings: settings,
            );
          case AppRoutes.productDetailsPage:
            final args = settings.arguments as Map<String, dynamic>;
            return TransitionAnimations.slideRoute(
              ProductDetailsPage(
                product: args['product'] as ProductModel,
                productIndex: args['index'] as int,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
