import 'package:hive/hive.dart';
import 'package:stock_pilot/data/local/hive/hive_boxes.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class HiveService implements HiveServiceLayer {
  static Future<void> init() async {
    await Hive.openBox<UserProfile>(HiveBoxes.userProfile);
  }

  @override
  Future<void> addUser(UserProfile user) async {
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    box.add(user);
  }
}
