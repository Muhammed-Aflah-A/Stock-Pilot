part of 'cart_model.dart';

class CartItemsAdapter extends TypeAdapter<CartItems> {
  @override
  final int typeId = 8;

  @override
  CartItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItems(
      product: fields[0] as ProductModel,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItems obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SalesItemsAdapter extends TypeAdapter<SalesItems> {
  @override
  final int typeId = 9;

  @override
  SalesItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesItems(
      customerName: fields[0] as String?,
      customerNumber: fields[1] as String?,
      date: fields[2] as String,
      items: (fields[3] as List).cast<CartItems>(),
      totalAmount: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SalesItems obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.customerNumber)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.totalAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
