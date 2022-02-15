// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceInfoModelAdapter extends TypeAdapter<VoiceInfoModel> {
  @override
  final int typeId = 0;

  @override
  VoiceInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceInfoModel(
      name: fields[0] as String,
      enName: fields[1] as String,
      titles: (fields[2] as List).cast<Titles>(),
      avatar: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceInfoModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.enName)
      ..writeByte(2)
      ..write(obj.titles)
      ..writeByte(3)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TitlesAdapter extends TypeAdapter<Titles> {
  @override
  final int typeId = 1;

  @override
  Titles read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Titles(
      text: fields[0] as String,
      voices: (fields[1] as List).cast<String>(),
      content: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Titles obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.voices)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitlesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
