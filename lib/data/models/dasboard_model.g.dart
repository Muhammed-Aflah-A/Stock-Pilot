part of 'dasboard_model.dart';


class DashboardCardsAdapter extends TypeAdapter<DashboardCards> {
  @override
  final int typeId = 3;

  @override
  DashboardCards read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardCards(
      title: fields[0] as String?,
      value: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardCards obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardCardsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DasboardActivityAdapter extends TypeAdapter<DasboardActivity> {
  @override
  final int typeId = 4;

  @override
  DasboardActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DasboardActivity(
      image: fields[0] as String?,
      title: fields[1] as String?,
      product: fields[2] as String?,
      category: fields[3] as String?,
      unit: fields[4] as int?,
      label: fields[5] as String?,
      isPositive: fields[6] as bool?,
      date: fields[7] as String?,
      customerName: fields[8] as String?,
      customerNumber: fields[9] as String?,
      brand: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DasboardActivity obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.isPositive)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.customerName)
      ..writeByte(9)
      ..write(obj.customerNumber)
      ..writeByte(10)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DasboardActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
