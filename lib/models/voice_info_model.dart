import 'package:hive/hive.dart';

part 'voice_info_model.g.dart';

@HiveType(typeId: 0)
class VoiceInfoModel {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String enName;
  @HiveField(2)
  late List<Titles> titles;

  static VoiceInfoModel init() =>
      VoiceInfoModel(name: '', enName: '', titles: []);

  VoiceInfoModel(
      {required this.name, required this.enName, required this.titles});

  VoiceInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    enName = json['en_name'];
    if (json['titles'] != null) {
      titles = <Titles>[];
      json['titles'].forEach((v) {
        titles.add(Titles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['en_name'] = enName;
    data['titles'] = titles.map((v) => v.toJson()).toList();
    return data;
  }
}

@HiveType(typeId: 1)
class Titles {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late List<String> voices;

  @HiveField(2)
  late String content;

  Titles({required this.text, required this.voices, required this.content});

  Titles.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    voices = json['voices'].cast<String>();
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['voices'] = voices;
    data['content'] = content;
    return data;
  }
}
