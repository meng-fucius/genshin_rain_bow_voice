import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:rain_bow_genshin_voices/models/role_model.dart';
import 'package:rain_bow_genshin_voices/models/voice_info_model.dart';

final vo = VoiceFetch();

class VoiceFetch {
  Future<VoiceInfoModel?> htmlParse(Role role) async {
    Response res;
    try {
      res = await Dio().get('https://wiki.biligame.com/ys/${role.zhName}语音');
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      } else {
        BotToast.showText(text: '${role.zhName}不存在');
      }
      return null;
    }
    VoiceInfoModel _voiceInfo = VoiceInfoModel.init();
    _voiceInfo.name = role.zhName;
    _voiceInfo.enName = role.enName;
    var document = parse(res.data.toString());
    var elements = document.getElementsByClassName('wikitable');
    RegExp reg = RegExp(r'data-src="(.*?)"');
    var matches = reg.allMatches(document.outerHtml);
    List<String> links = matches.map((e) => e.group(1).toString()).toList();
    links = links.toSet().toList();
    var count = 0;

    try {
      if (elements.length > 2) {
        for (var i = 2; i < elements.length; i++) {
          var strs = textParse(elements[i].text);
          var _voList = <String>[];
          for (var j = 0; j < 4; j++) {
            _voList.add(links[count]);
            count++;
          }
          _voiceInfo.titles.add(Titles(
              text: strs[0].trim(), voices: _voList, content: strs[5].trim()));
        }
      } else {
        if (kDebugMode) {
          print('${role.zhName} 错误');
        } else {
          BotToast.showText(text: '${role.zhName}语音错误');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('${role.zhName}角色语音缺失');
      } else {
        BotToast.showText(text: '${role.zhName}角色语音缺失');
      }
      return null;
    }

    return _voiceInfo;
  }

  List<String> textParse(String body) {
    var spans = body.split('\n\n');
    var title = spans[1];
    var zh = spans[2].replaceAll('\n', '');
    var jp = spans[3].replaceAll('\n', '');
    var en = spans[4].replaceAll('\n', '');
    var kr = spans[5].replaceAll('\n', '');
    var subTitle = spans[11].replaceAll('\n', '');
    return [title, zh, jp, en, kr, subTitle];
  }

  Future getAvatar(String name) async {
    var res =
        await Dio().get('https://wiki.biligame.com/ys/%E8%A7%92%E8%89%B2');

    var document = parse(res.data.toString());
    var elements = document.getElementsByClassName('floatnone');
    if (elements.isEmpty) {
      return null;
    }
    final aElement = elements.first.getElementsByTagName('a');
    if (aElement.isEmpty) {
      return null;
    }
    final name = aElement.first.attributes['title'];
    final img = aElement.first.getElementsByTagName('img');
    final imgPath = img.first.attributes['src'];
    print('$name,$imgPath');
  }

  Future getVoices() async {
    var res = await Dio().get('https://wiki.biligame.com/ys/神里绫华语音');
    var document = parse(res.data.toString());
    var elements = document.getElementsByClassName('wikitable');
    var tElement = elements[2].getElementsByTagName('tr');
    print(tElement.length);
    var title = tElement.first.text.replaceAll('\n', '').trim();
    print(title);
    var vElement = tElement[2].getElementsByTagName('td');
    var voiceElement = vElement.first.getElementsByTagName('div');
    print(voiceElement.length);
    var voicePath = voiceElement.first.attributes['data-src'];
    print(voicePath);
    var div = voiceElement.first
        .getElementsByClassName('bikited-audio default-player');
    print(div.length);
    print(div.first.attributes['src']);
  }
}
