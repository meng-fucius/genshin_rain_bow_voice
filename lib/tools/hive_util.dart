import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rain_bow_genshin_voices/models/voice_info_model.dart';

class HiveUtil {
  static Box? _dataBox;

  static Box? get dataBox => _dataBox;

  static Future init() async {
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Hive.registerAdapter(VoiceInfoModelAdapter());
      Hive.registerAdapter(TitlesAdapter());
      _dataBox = await Hive.openBox('dataBox');
    }
  }
}
