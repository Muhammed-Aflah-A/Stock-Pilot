import 'package:hive/hive.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class HiveService implements HiveServiceLayer {
  static Future<void> init() async {
    await Hive.openBox<UserProfile>(HiveBoxes.userProfile);
    await Hive.openBox<ProductModel>(HiveBoxes.productList);
    await Hive.openBox<CategoryModel>(HiveBoxes.categories);
    await Hive.openBox<BrandModel>(HiveBoxes.brands);
    await Hive.openBox<DasboardActivity>(HiveBoxes.dashBoardActivity);
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
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    await box.put('user', user);
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(HiveBoxes.productList);
    await box.add(product);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final box = Hive.box<ProductModel>(HiveBoxes.productList);
    return box.values.toList();
  }

  @override
  Future<void> updateProduct(int index, ProductModel product) async {
    final box = Hive.box<ProductModel>(HiveBoxes.productList);
    await box.putAt(index, product);
  }

  @override
  Future<void> deleteProduct(int index) async {
    final box = Hive.box<ProductModel>(HiveBoxes.productList);
    await box.deleteAt(index);
  }

  @override
  Future<void> addActivity(DasboardActivity activity) async {
    final box = Hive.box<DasboardActivity>(HiveBoxes.dashBoardActivity);
    await box.add(activity);
  }

  @override
  Future<List<DasboardActivity>> getAllActivities() async {
    final box = Hive.box<DasboardActivity>(HiveBoxes.dashBoardActivity);
    return box.values.toList().reversed.toList();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final box = Hive.box<CategoryModel>(HiveBoxes.categories);
    await box.add(category);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final box = Hive.box<CategoryModel>(HiveBoxes.categories);
    return box.values.toList();
  }

  @override
  Future<void> updateCategory(int index, CategoryModel category) async {
    final box = Hive.box<CategoryModel>(HiveBoxes.categories);
    await box.putAt(index, category);
  }

  @override
  Future<void> deleteCategory(int index) async {
    final box = Hive.box<CategoryModel>(HiveBoxes.categories);
    await box.deleteAt(index);
  }

  @override
  Future<void> addBrand(BrandModel brand) async {
    final box = Hive.box<BrandModel>(HiveBoxes.brands);
    await box.add(brand);
  }

  @override
  Future<List<BrandModel>> getAllBrands() async {
    final box = Hive.box<BrandModel>(HiveBoxes.brands);
    return box.values.toList();
  }

  @override
  Future<void> updateBrand(int index, BrandModel brands) async {
    final box = Hive.box<BrandModel>(HiveBoxes.brands);
    await box.putAt(index, brands);
  }

  @override
  Future<void> deleteBrand(int index) async {
    final box = Hive.box<BrandModel>(HiveBoxes.brands);
    await box.deleteAt(index);
  }
}
