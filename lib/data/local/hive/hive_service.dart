import 'package:hive/hive.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class HiveService implements HiveServiceLayer {
  static Future<void> init() async {
    await Hive.openBox<UserProfile>(HiveBoxes.userProfile);
    await Hive.openBox<ProductModel>(HiveBoxes.productList);
  }

  @override
  Future<void> addUser(UserProfile user) async {
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    box.put("user", user);
  }

  @override
  Future<UserProfile?> getUser() async {
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    return box.get('user');
  }

  @override
  Future<void> updateUser(UserProfile user) async {
    final box = await Hive.openBox<UserProfile>(HiveBoxes.userProfile);
    await box.put('user', user);
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(HiveBoxes.productList);
    await box.add(product);
  }
}
