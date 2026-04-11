import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/navigation/transition_animation.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/local/hive/hive_adapters.dart';
import 'package:stock_pilot/data/local/hive/hive_service.dart';
import 'package:stock_pilot/presentation/brand/screens/brand_list_page.dart';
import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/cart/screen/billing_page.dart';
import 'package:stock_pilot/presentation/cart/screen/cart_list_page.dart';
import 'package:stock_pilot/presentation/cart/screen/confirmation_page.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
import 'package:stock_pilot/presentation/history/viewmodel/history_provider.dart';
import 'package:stock_pilot/presentation/category/screens/category_list_page.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/history/screens/history_detail_page.dart';
import 'package:stock_pilot/presentation/history/screens/history_list_page.dart';
import 'package:stock_pilot/presentation/category/viewmodel/category_provider.dart';
import 'package:stock_pilot/presentation/dashboard/screens/dashboard.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/presentation/introduction/screens/onboarding_screen_1.dart';
import 'package:stock_pilot/presentation/introduction/screens/splash_screen.dart';
import 'package:stock_pilot/presentation/introduction/screens/onboarding_screen_2.dart';
import 'package:stock_pilot/presentation/introduction/screens/onboarding_screen_3.dart';
import 'package:stock_pilot/presentation/introduction/screens/profile_creation.dart';
import 'package:stock_pilot/presentation/introduction/view_model/onboarding_screen_provider.dart';
import 'package:stock_pilot/presentation/introduction/view_model/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/introduction/view_model/splash_screen_provider.dart';
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
import 'package:stock_pilot/presentation/revenue/screens/revenue_page.dart';

import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_US', null);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: ColourStyles.primaryColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Hive.initFlutter();
  HiveAdapters.register();
  await HiveService.init();
  final hiveService = HiveService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingScreenProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileCreationProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePageProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => BrandProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(hiveService: hiveService),
        ),
        ChangeNotifierProvider(
          create: (_) => RevenueProvider(hiveService: hiveService),
        ),
        ChangeNotifierProxyProvider2<
          CategoryProvider,
          BrandProvider,
          ProductProvider
        >(
          create: (context) => ProductProvider(hiveService: hiveService),
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

// Custom scroll behavior to remove Android stretch overscroll effect
class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class StockPilot extends StatelessWidget {
  const StockPilot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: NoStretchScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: "StockPilot",
      initialRoute: AppRoutes.splashScreen,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping anywhere outside text fields
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
      // Added global keyboard dismissal on every navigation transition
      navigatorObservers: [RouteObserver<ModalRoute<void>>()],
      onGenerateRoute: (settings) {
        // Ensure keyboard is dismissed before any navigation starts
        FocusManager.instance.primaryFocus?.unfocus();
        switch (settings.name) {
          //Fade animation
          case AppRoutes.splashScreen:
            return TransitionAnimations.fadeRoute(
              const SplashScreen(),
              settings: settings,
            );
          case AppRoutes.onBoardingScreen_1:
            return TransitionAnimations.fadeRoute(
              const OnboardingScreen1(),
              settings: settings,
            );
          case AppRoutes.profileCreation:
            return TransitionAnimations.fadeRoute(
              const ProfileCreation(),
              settings: settings,
            );
          case AppRoutes.dashboard:
            return TransitionAnimations.fadeRoute(
              const Dashboard(),
              settings: settings,
            );
          case AppRoutes.profilePage:
            return TransitionAnimations.fadeRoute(
              const ProfilePage(),
              settings: settings,
            );
          case AppRoutes.productListPage:
            return TransitionAnimations.fadeRoute(
              const ProductListPage(),
              settings: settings,
            );
          case AppRoutes.productAddingPage1:
            return TransitionAnimations.fadeRoute(
              ProductAddingPage1(),
              settings: settings,
            );
          case AppRoutes.category:
            return TransitionAnimations.fadeRoute(
              const CategoryListPage(),
              settings: settings,
            );
          case AppRoutes.brand:
            return TransitionAnimations.fadeRoute(
              const BrandListPage(),
              settings: settings,
            );
          case AppRoutes.lowStockPage:
            return TransitionAnimations.fadeRoute(
              const LowstockListPage(),
              settings: settings,
            );
          case AppRoutes.outOfStockPage:
            return TransitionAnimations.fadeRoute(
              const OutOfStockListPage(),
              settings: settings,
            );
          case AppRoutes.cartListPage:
            return TransitionAnimations.fadeRoute(
              const CartListPage(),
              settings: settings,
            );
          case AppRoutes.conformationPage:
            return TransitionAnimations.fadeRoute(
              const ConfirmationPage(),
              settings: settings,
            );
          case AppRoutes.historyListPage:
            return TransitionAnimations.fadeRoute(
              const HistoryListPage(),
              settings: settings,
            );
          case AppRoutes.revenuePage:
            return TransitionAnimations.fadeRoute(
              const RevenuePage(),
              settings: settings,
            );

          //Slide animation
          case AppRoutes.onBoardingScreen_2:
            return TransitionAnimations.slideRoute(
              const OnboardingScreen2(),
              settings: settings,
            );
          case AppRoutes.onBoardingScreen_3:
            return TransitionAnimations.slideRoute(
              const OnboardingScreen3(),
              settings: settings,
            );
          case AppRoutes.productAddingPage2:
            return TransitionAnimations.slideRoute(
              ProductAddingPage2(),
              settings: settings,
            );
          case AppRoutes.productDetailsPage:
            return TransitionAnimations.slideRoute(
              const ProductDetailsPage(),
              settings: settings,
            );
          case AppRoutes.billingPage:
            return TransitionAnimations.slideRoute(
              BillingPage(),
              settings: settings,
            );
          case AppRoutes.historyDetailsPage:
            final activity = settings.arguments as DasboardActivity;
            return TransitionAnimations.slideRoute(
              HistoryDetailPage(activity: activity),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
