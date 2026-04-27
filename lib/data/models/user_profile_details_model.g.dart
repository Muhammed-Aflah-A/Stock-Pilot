// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileDetailsModelAdapter
    extends TypeAdapter<UserProfileDetailsModel> {
  @override
  final int typeId = 2;

  @override
  UserProfileDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileDetailsModel(
      leadingIcon: fields[0] as IconData?,
      title: fields[1] as String?,
      subtitle: fields[2] as String?,
      trailingIcon: fields[3] as IconData?,
      feildtype: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileDetailsModel obj) {
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
      other is UserProfileDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
