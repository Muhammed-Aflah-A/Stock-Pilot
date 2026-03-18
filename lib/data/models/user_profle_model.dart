import 'package:hive/hive.dart';
part 'user_profle_model.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  String? profileImage;
  @HiveField(1)
  String? fullName;
  @HiveField(2)
  String? personalNumber;
  @HiveField(3)
  String? shopName;
  @HiveField(4)
  String? shopAddress;
  @HiveField(5)
  String? shopNumber;
  @HiveField(6)
  String? gmail;
  UserProfile({
    this.profileImage,
    required this.fullName,
    required this.personalNumber,
    required this.shopName,
    required this.shopAddress,
    required this.shopNumber,
    required this.gmail,
  });
}
