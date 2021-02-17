// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsTopic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubsTopicAdapter extends TypeAdapter<SubsTopic> {
  @override
  final int typeId = 0;

  @override
  SubsTopic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubsTopic(
      topic: fields[0] as String,
      label: fields[1] as String,
      mosqueId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubsTopic obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.topic)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.mosqueId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubsTopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
