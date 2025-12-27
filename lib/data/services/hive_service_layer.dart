import 'package:stock_pilot/data/models/user_profle_model.dart';

abstract class HiveServiceLayer {
  Future<void> addUser(UserProfile user);
  Future<UserProfile?> getUser();
  Future<void> updateUser(UserProfile user);
}
