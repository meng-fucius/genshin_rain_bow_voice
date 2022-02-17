import 'package:bwiki_ys/src/constants/b_path.dart';
import 'package:bwiki_ys/src/models/i10n_model.dart';
import 'package:bwiki_ys/src/models/role_list_item_model.dart';
import 'package:bwiki_ys/src/models/voice_item_model.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class BWikiYs {
  late Dio _dio;
  BWikiYs() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://wiki.biligame.com',
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/96.0.4664.55 Safari/537.36'
      },
    ));
  }

  /// 角色列表
  ///
  /// https://wiki.biligame.com/ys/角色
  Future<List<RoleListItemModel>> roleList() async {
    final res = await _dio.get(BPath.role);
    if (res.statusCode != 200) return [];
    final document = parse(res.data);
    List<Element> boxes = document.body!.getElementsByClassName('home-box-tag');
    List<RoleListItemModel> items = [];
    for (var singleBox in boxes) {
      final imageDivs = singleBox.getElementsByClassName('home-box-tag-1');
      if (imageDivs.isEmpty) continue;
      final linkElement = imageDivs.first.getElementsByTagName('a');
      if (linkElement.isEmpty) continue;
      final name = linkElement.first.attributes['title'] ?? '';
      final nextLink = linkElement.first.attributes['href'] ?? '';
      final imageList = linkElement.first.getElementsByTagName('img');

      if (imageList.isEmpty) continue;
      final image = imageList.first.attributes['src'] ?? '';
      items.add(RoleListItemModel(name: name, image: image, path: nextLink));
    }
    return items;
  }

  /// 语音列表
  ///
  /// https://wiki.biligame.com/ys/[name]语音
  Future<List<VoiceItemModel>> getVoiceList(String name) async {
    final res = await _dio.get(BPath.voicePath(name));
    if (res.statusCode != 200) return [];
    final document = parse(res.data);
    final base = document.body!.getElementsByClassName('resp-tab-content');
    if (base.isEmpty) return [];
    final baseItems = base.first.getElementsByClassName('visible-md');
    List<VoiceItemModel> voiceItems = [];
    for (var item in baseItems) {
      if (item.nodes.isEmpty || item.nodes.first.nodes.isEmpty) continue;
      final title = item.nodes.first.nodes.first.text ?? '';
      final desc = item.nodes.first.nodes.last.text ?? '';
      final allItems = item.nodes.first.children;
      final midItems = allItems.getRange(1, allItems.length - 1);
      List<I10nModel> i10nModels = [];
      int i = 0;
      for (var voiceItem in midItems) {
        final rawVoice = voiceItem.getElementsByClassName('bikit-audio');
        if (rawVoice.isEmpty) continue;
        final src = rawVoice.first.attributes['data-src'] ?? '';
        final lang = Launguage.values[i];
        i10nModels.add(I10nModel(launguage: lang, path: src));
        i++;
      }
      voiceItems.add(
        VoiceItemModel(
            name: name, locales: i10nModels, title: title, description: desc),
      );
    }
    return voiceItems;
  }

  /// 语音列表
  Future<List<VoiceItemModel>> getVoiceListbyRole(RoleListItemModel role) =>
      getVoiceList(role.name);
}
