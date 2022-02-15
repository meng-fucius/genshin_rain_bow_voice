import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:rain_bow_genshin_voices/models/role_model.dart';
import 'package:rain_bow_genshin_voices/models/voice_info_model.dart';
import 'package:rain_bow_genshin_voices/tools/hive_util.dart';

import '../tools/html/voice_fetch.dart';

class RoleData extends ChangeNotifier {
  List<VoiceInfoModel> _list = [];

  List<VoiceInfoModel> get list => _list;

  final List<Role> _roles = [Role(zhName: '神里绫华', enName: 'kamisato_ayaka')];

  List<Role> get roles => _roles;

  bool _containRole(String name) {
    for (var item in _list) {
      if (item.name == name) {
        return true;
      }
    }
    return false;
  }

  Future init() async {
    _list = HiveUtil.dataBox!.values.cast<VoiceInfoModel>().toList();
    if (_list.isEmpty) {
      await updateAllVoice();
    }
    if (_list.length < roles.length) {
      updateVoice();
    }
    notifyListeners();
  }

  Future updateVoice() async {
    var cancel = BotToast.showLoading();
    var errorIndex = [];
    for (var item in _roles) {
      if (_containRole(item.zhName)) {
        continue;
      }
      var re = await vo.htmlParse(item);
      if (re == null) {
        errorIndex.add(item);
        continue;
      }
      _list.add(re);
      HiveUtil.dataBox!.add(re);
      BotToast.showText(text: '已添加${re.name}');
    }
    if (errorIndex.isNotEmpty) {
      for (var item in errorIndex) {
        _roles.remove(item);
      }
    }
    cancel();
    notifyListeners();
  }

  Future updateAllVoice() async {
    var cancel = BotToast.showLoading();
    _list.clear();
    var errorIndex = [];
    for (var item in _roles) {
      var re = await vo.htmlParse(item);
      if (re == null) {
        errorIndex.add(item);
        continue;
      }
      _list.add(re);
    }
    if (errorIndex.isNotEmpty) {
      for (var item in errorIndex) {
        _roles.remove(item);
      }
    }
    HiveUtil.dataBox!.clear();
    HiveUtil.dataBox!.addAll(_list);
    BotToast.showText(text: '已更新所有角色');
    cancel();
    notifyListeners();
  }

  void addRole(Role role) {
    _roles.add(role);
    notifyListeners();
  }
}
