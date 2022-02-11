class MainfestModel {
  late String name;
  late String displayName;
  late String avatar;
  late String avatarDark;
  late String version;
  late String description;
  late List<String> languages;
  late String author;
  late String gender;
  late String locale;
  late List<Contributes> contributes;

  MainfestModel(
      {this.name = '',
      required this.displayName,
      required this.avatar,
      required this.avatarDark,
      required this.version,
      required this.description,
      required this.languages,
      required this.author,
      required this.gender,
      required this.locale,
      required this.contributes});

  static MainfestModel init() => MainfestModel(
      displayName: '',
      avatar: '',
      avatarDark: '',
      version: '',
      description: '',
      languages: [],
      author: '',
      gender: '',
      locale: 'zh',
      contributes: [Contributes.init()]);

  MainfestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['display-name'];
    avatar = json['avatar'];
    avatarDark = json['avatar-dark'];
    version = json['version'];
    description = json['description'];
    languages = json['languages'].cast<String>();
    author = json['author'];
    gender = json['gender'];
    locale = json['locale'];
    if (json['contributes'] != null) {
      contributes = <Contributes>[];
      json['contributes'].forEach((v) {
        contributes.add(Contributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['display-name'] = displayName;
    data['avatar'] = avatar;
    data['avatar-dark'] = avatarDark;
    data['version'] = version;
    data['description'] = description;
    data['languages'] = languages;
    data['author'] = author;
    data['gender'] = gender;
    data['locale'] = locale;
    data['contributes'] = contributes.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contributes {
  late List<String> titles;
  late List<String> keywords;
  late List<String> voices;

  Contributes(
      {required this.keywords, required this.voices, required this.titles});

  static Contributes init() =>
      Contributes(keywords: [], voices: [], titles: []);

  Contributes.fromJson(Map<String, dynamic> json) {
    keywords = json['keywords'].cast<String>();
    voices = json['voices'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keywords'] = keywords;
    data['voices'] = voices;
    return data;
  }
}
