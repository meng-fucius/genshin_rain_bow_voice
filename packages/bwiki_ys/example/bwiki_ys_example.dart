import 'package:bwiki_ys/bwiki_ys.dart';

void main() async {
  for (var item in await BWikiYs().roleList()) {
    print(item.path);
  }
  for (var item in await BWikiYs().getVoiceList('可莉')) {
    print(item.locales.first.path);
  }
}
