import 'package:bwiki_ys/src/models/i10n_model.dart';

class VoiceItemModel {
  final String name;
  final List<I10nModel> locales;
  final String title;
  final String description;
  VoiceItemModel({
    required this.name,
    required this.locales,
    required this.title,
    required this.description,
  });
}
