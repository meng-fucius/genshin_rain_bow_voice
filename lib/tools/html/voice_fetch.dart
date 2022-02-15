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
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      } else {
        BotToast.showText(text: '${role.zhName}不存在');
      }
      return null;
    }
    var avatar = await getAvatar(role.zhName);
    await Future.delayed(const Duration(milliseconds: 500));
    VoiceInfoModel _voiceInfo = VoiceInfoModel.init();
    _voiceInfo.name = role.zhName;
    _voiceInfo.enName = role.enName;
    _voiceInfo.avatar = avatar;
    var document = parse(res.data.toString());
    var elements = document.getElementsByClassName('wikitable');
    for (var i = 2; i < elements.length; i++) {
      Titles _voiceTitle = Titles(text: '', voices: [], content: '');
      var tElement = elements[i].getElementsByTagName('tr');
      _voiceTitle.text = tElement.first.text.replaceAll('\n', '').trim();
      _voiceTitle.content = tElement.last.text.replaceAll('\n', '').trim();
      var vElement = tElement[2].getElementsByTagName('td');
      for (var j = 0; j < 4; j++) {
        var voiceElement = vElement[j].getElementsByTagName('div');
        var voicePath = voiceElement.first.attributes['data-src'];
        if (voicePath != null) {
          _voiceTitle.voices.add(voicePath);
        } else {
          _voiceTitle.voices.add('');
        }
      }
      _voiceInfo.titles.add(_voiceTitle);
    }
    return _voiceInfo;
  }

  Future getAvatar(String name) async {
    try {
      var res =
          await Dio().get('https://wiki.biligame.com/ys/%E8%A7%92%E8%89%B2');
      var document = parse(res.data.toString());
      var elements = document.getElementsByClassName('home-box-tag-1');
      final aElements =
          elements.map((e) => e.getElementsByTagName('a')).toList();
      for (var item in aElements) {
        if (item.first.attributes['title'] == name) {
          return item[0].getElementsByTagName('img').first.attributes['src'];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      } else {
        BotToast.showText(text: '$name头像获取失败');
      }
    }
  }
}
