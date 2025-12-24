import 'package:flutter/material.dart';
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
  String? shopAdress;
  @HiveField(5)
  String? shopNumber;
  @HiveField(6)
  String? gmail;
  UserProfile({
    this.profileImage,
    required this.fullName,
    required this.personalNumber,
    required this.shopName,
    required this.shopAdress,
    required this.shopNumber,
    required this.gmail,
  });
}

@HiveType(typeId: 4)
class PersonalInfo {
  @HiveField(0)
  Icon? leadingIcon;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? subtitle;
  @HiveField(3)
  Icon? trailingIcon;
  @HiveField(4)
  String? feildtype;
  PersonalInfo({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.feildtype,
  });
}

@HiveType(typeId: 5)
class ShopInfo {
  @HiveField(0)
  Icon? leadingIcon;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? subtitle;
  @HiveField(3)
  Icon? trailingIcon;
  @HiveField(4)
  String? feildtype;
  ShopInfo({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.feildtype,
  });
}
