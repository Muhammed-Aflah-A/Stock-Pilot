import 'package:hive/hive.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/drawer_items_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';

class HiveAdapters {
  static void register() {
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(DrawerItemsAdapter());
    Hive.registerAdapter(DasboardModelAdapter());
  }
}
