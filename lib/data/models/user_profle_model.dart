import 'package:hive/hive.dart';
part 'user_profle_model.g.dart';
@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  String? fullName;
  @HiveField(1)
  String? shopName;
  @HiveField(2)
  String? shopAdress;
  @HiveField(3)
  String? gmail;
  @HiveField(4)
  String? phoneNumber;
  UserProfile({
    required this.fullName,
    required this.shopName,
    required this.shopAdress,
    required this.gmail,
    required this.phoneNumber,
  });
}
