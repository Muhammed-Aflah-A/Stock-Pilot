// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      profileImage: fields[0] as String?,
      fullName: fields[1] as String?,
      personalNumber: fields[2] as String?,
      shopName: fields[3] as String?,
      shopAdress: fields[4] as String?,
      shopNumber: fields[5] as String?,
      gmail: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.profileImage)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.personalNumber)
      ..writeByte(3)
      ..write(obj.shopName)
      ..writeByte(4)
      ..write(obj.shopAdress)
      ..writeByte(5)
      ..write(obj.shopNumber)
      ..writeByte(6)
      ..write(obj.gmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalInfoAdapter extends TypeAdapter<PersonalInfo> {
  @override
  final int typeId = 4;

  @override
  PersonalInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalInfo(
      leadingIcon: fields[0] as Icon?,
      title: fields[1] as String?,
      subtitle: fields[2] as String?,
      trailingIcon: fields[3] as Icon?,
      feildtype: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.leadingIcon)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.trailingIcon)
      ..writeByte(4)
      ..write(obj.feildtype);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopInfoAdapter extends TypeAdapter<ShopInfo> {
  @override
  final int typeId = 5;

  @override
  ShopInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopInfo(
      leadingIcon: fields[0] as Icon?,
      title: fields[1] as String?,
      subtitle: fields[2] as String?,
      trailingIcon: fields[3] as Icon?,
      feildtype: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.leadingIcon)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.trailingIcon)
      ..writeByte(4)
      ..write(obj.feildtype);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
