import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';

abstract class HiveServiceLayer {
  Future<void> addUser(UserProfile user);
  Future<UserProfile?> getUser();
  Future<void> updateUser(UserProfile user);
  Future<void> addProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
  Future<void> updateProduct(int index, ProductModel product);
  Future<void> deleteProduct(int index);
  Future<void> addCategory(CategoryModel category);
  Future<List<CategoryModel>> getAllCategories();
  Future<void> updateCategory(int index, CategoryModel category);
  Future<void> deleteCategory(int index);
  Future<void> addBrand(BrandModel brand);
  Future<List<BrandModel>> getAllBrands();
  Future<void> updateBrand(int index, BrandModel category);
  Future<void> deleteBrand(int index);
  Future<void> addActivity(DasboardActivity activity);
  Future<List<DasboardActivity>> getAllActivities();
}
