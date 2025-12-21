import 'package:hive/hive.dart';
part 'user_profle_model.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  String? profileImage;
  @HiveField(1)
  String? fullName;
  @HiveField(2)
  String? shopName;
  @HiveField(3)
  String? shopAdress;
  @HiveField(4)
  String? gmail;
  @HiveField(5)
  String? phoneNumber;
  UserProfile({
    this.profileImage,
    required this.fullName,
    required this.shopName,
    required this.shopAdress,
    required this.gmail,
    required this.phoneNumber,
  });
}
