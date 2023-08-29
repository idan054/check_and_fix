// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallsAdapter extends TypeAdapter<Calls> {
  @override
  final int typeId = 0;

  @override
  Calls read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calls(
      type: fields[4] as String?,
      duration: fields[1] as String?,
      dateTime: fields[5] as DateTime?,
      date: fields[0] as String?,
      mobileNumber: fields[2] as String?,
      name: fields[3] as String?,
      isHide: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Calls obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.mobileNumber)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.isHide);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
