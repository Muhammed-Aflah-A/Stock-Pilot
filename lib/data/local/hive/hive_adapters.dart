import 'package:hive/hive.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/drawer_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/models/user_profile_details_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';

class HiveAdapters {
  static void register() {
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(UserProfileDetailsModelAdapter());
    Hive.registerAdapter(DrawerItemsAdapter());
    Hive.registerAdapter(DashboardCardsAdapter());
    Hive.registerAdapter(DasboardActivityAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(BrandModelAdapter());
    Hive.registerAdapter(CartItemsAdapter());
    Hive.registerAdapter(SalesItemsAdapter());
  }
}
