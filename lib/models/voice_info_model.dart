class VoiceInfoModel {
  late String name;
  late String enName;
  late List<Titles> titles;

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

class Titles {
  late String text;
  late List<String> voices;
  late String content;

  Titles({required this.text, required this.voices, required this.content});

  Titles.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    voices = json['voices'].cast<String>();
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['voices'] = this.voices;
    data['content'] = this.content;
    return data;
  }
}
