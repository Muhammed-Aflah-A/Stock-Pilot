// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dasboard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DasboardModelAdapter extends TypeAdapter<DasboardModel> {
  @override
  final int typeId = 2;

  @override
  DasboardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DasboardModel(
      image: fields[0] as String?,
      title: fields[1] as String?,
      product: fields[2] as String?,
      category: fields[3] as String?,
      unit: fields[4] as int?,
      label: fields[5] as String?,
      isPositive: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, DasboardModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.label)
      ..writeByte(6)
      ..write(obj.isPositive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DasboardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
