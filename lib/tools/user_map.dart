import 'package:rain_bow_genshin_voices/tools/enum.dart';

class UserMap {
  static language(Language language) {
    switch (language) {
      case Language.zh:
        return '简体中文';
      case Language.jp:
        return '日语';
      case Language.en:
        return '英语';
      case Language.kr:
        return '韩语';
    }
  }
}
