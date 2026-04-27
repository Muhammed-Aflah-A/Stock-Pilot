// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 5;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      productImages: (fields[0] as List).cast<String>(),
      productName: fields[1] as String?,
      productDescription: fields[2] as String?,
      brand: fields[3] as String?,
      category: fields[4] as String?,
      purchaseRate: fields[5] as String?,
      salesRate: fields[6] as String?,
      itemCount: fields[7] as String?,
      lowStockCount: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.productImages)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.productDescription)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.purchaseRate)
      ..writeByte(6)
      ..write(obj.salesRate)
      ..writeByte(7)
      ..write(obj.itemCount)
      ..writeByte(8)
      ..write(obj.lowStockCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
