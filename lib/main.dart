import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
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
import 'package:stock_pilot/presentation/indroduction/view_model/onboarding_screen_provider.dart';
import 'package:stock_pilot/presentation/indroduction/view_model/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/indroduction/view_model/splash_screen_provider.dart';
import 'package:stock_pilot/presentation/low%20stock/screens/lowstock_list_page.dart';
import 'package:stock_pilot/presentation/low%20stock/viewmodel/lowStock_provider.dart';
import 'package:stock_pilot/presentation/out%20of%20stock/screens/out_of_stock_list_page.dart';
import 'package:stock_pilot/presentation/out%20of%20stock/viewmodel/outofstock_provider.dart';
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
      statusBarColor: ColourStyles.primaryColor,
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
        ChangeNotifierProvider(create: (_) => OnboardingScreenProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(hiveService: HiveService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(hiveService: HiveService()),
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
          create: (context) => ProductProvider(hiveService: HiveService()),
          update: (context, categoryProvider, brandProvider, productProvider) {
            final provider = productProvider!;
            provider.setCategories(categoryProvider.categories);
            provider.setBrands(brandProvider.brands);
            return productProvider;
          },
        ),
        ChangeNotifierProxyProvider<ProductProvider, LowstockProvider>(
          create: (_) => LowstockProvider(),
          update: (_, productProvider, lowstockProvider) {
            lowstockProvider!.updateProductProvider(productProvider);
            return lowstockProvider;
          },
        ),
        ChangeNotifierProxyProvider<ProductProvider, OutofstockProvider>(
          create: (_) => OutofstockProvider(),
          update: (_, productProvider, outProvider) {
            outProvider!.updateProductProvider(productProvider);
            return outProvider;
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
            return TransitionAnimations.fadeRoute(ProductAddingPage1());
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
            return TransitionAnimations.slideRoute(ProductAddingPage2());
          case AppRoutes.productDetailsPage:
            final args = settings.arguments as Map<String, dynamic>;
            return TransitionAnimations.slideRoute(
              ProductDetailsPage(productIndex: args['index'] as int),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
