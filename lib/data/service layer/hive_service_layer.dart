import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/data/models/dasboard_model.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/models/notification_model.dart';

abstract class HiveServiceLayer {
  Future<void> addUser(UserProfile user);
  Future<UserProfile?> getUser();
  Future<void> updateUser(UserProfile user);

  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(int index, ProductModel product);
  Future<void> deleteProduct(int index);
  Future<List<ProductModel>> getAllProducts();

  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(int index, CategoryModel category);
  Future<void> deleteCategory(int index);
  Future<List<CategoryModel>> getAllCategories();

  Future<void> addBrand(BrandModel brand);
  Future<void> updateBrand(int index, BrandModel category);
  Future<void> deleteBrand(int index);
  Future<List<BrandModel>> getAllBrands();

  Future<void> addActivity(DasboardActivity activity);
  Future<List<DasboardActivity>> getAllActivities();

  Future<void> addToCart(CartItems item);
  Future<void> updateCartItem(int index, CartItems item);
  Future<void> removeFromCart(int index);
  Future<List<CartItems>> getCartItems();
  Future<void> clearCart();

  Future<void> addSale(SalesItems sale);
  Future<List<SalesItems>> getAllSales();

  Future<void> addNotification(NotificationModel notification);
  Future<void> updateNotification(NotificationModel notification);
  Future<List<NotificationModel>> getAllNotifications();
  Future<void> deleteNotification(int index);
  Future<void> markAllNotificationsAsRead();
}
