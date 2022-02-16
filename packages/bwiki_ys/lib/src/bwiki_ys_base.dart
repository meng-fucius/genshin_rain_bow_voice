import 'package:bwiki_ys/src/constants/b_path.dart';
import 'package:bwiki_ys/src/models/role_list_item_model.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class BWikiYs {
  late Dio _dio;
  BWikiYs() {
    _dio = Dio(BaseOptions(baseUrl: 'https://wiki.biligame.com'));
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
}
