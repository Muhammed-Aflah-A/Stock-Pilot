// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 12;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      dateTime: fields[3] as String,
      type: fields[4] as NotificationType,
      isRead: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 11;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.add;
      case 1:
        return NotificationType.update;
      case 2:
        return NotificationType.delete;
      case 3:
        return NotificationType.sale;
      case 4:
        return NotificationType.lowStock;
      case 5:
        return NotificationType.outOfStock;
      default:
        return NotificationType.add;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.add:
        writer.writeByte(0);
        break;
      case NotificationType.update:
        writer.writeByte(1);
        break;
      case NotificationType.delete:
        writer.writeByte(2);
        break;
      case NotificationType.sale:
        writer.writeByte(3);
        break;
      case NotificationType.lowStock:
        writer.writeByte(4);
        break;
      case NotificationType.outOfStock:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
