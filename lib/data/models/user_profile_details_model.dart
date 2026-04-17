import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user_profile_details_model.g.dart';
@HiveType(typeId: 2)
class UserProfileDetailsModel {
  @HiveField(0)
  IconData? leadingIcon;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? subtitle;
  @HiveField(3)
  IconData? trailingIcon;
  @HiveField(4)
  String? feildtype;
  UserProfileDetailsModel({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.feildtype,
  });
}

