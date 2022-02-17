enum Launguage {
  zh,
  jp,
  en,
  kr,
}


class I10nModel {
  final Launguage launguage;
  final String path;
  I10nModel({
    required this.launguage,
    required this.path,
  });
}
