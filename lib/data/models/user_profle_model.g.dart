
part of 'user_profle_model.dart';


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
      shopAddress: fields[4] as String?,
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
      ..write(obj.shopAddress)
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

