import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goose_ui/goose_ui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rain_bow_genshin_voices/models/mainfest_model.dart';
import 'package:rain_bow_genshin_voices/models/voice_info_model.dart';
import 'package:rain_bow_genshin_voices/providers/role_data.dart';
import 'package:rain_bow_genshin_voices/tools/enum.dart';
import 'package:rain_bow_genshin_voices/tools/extension/list_ext.dart';
import 'package:rain_bow_genshin_voices/tools/user_map.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({Key? key}) : super(key: key);

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  int get _selectRole =>
      _voices.indexWhere((element) => element.name == mainfestModel.name);

  Language _selectLan = Language.zh;

  int _selectTitle(int cindex, int index) =>
      _voices[_selectRole].titles.indexWhere((element) =>
          element.text == mainfestModel.contributes[cindex].titles[index]);

  List<VoiceInfoModel> get _voices =>
      Provider.of<RoleData>(context, listen: false).list;
  MainfestModel mainfestModel = MainfestModel.init();
  final TextEditingController _editingController = TextEditingController();

  final TextEditingController _programLanEditor = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final player = AudioPlayer();
  final double inputWidth = 500;
  final double titleWidth = 100;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () async {});
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _scrollController.dispose();
    _programLanEditor.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var gender = Row(
      children: [
        GRawCheckbox(
            value: mainfestModel.gender == 'female',
            onChange: (value) {
              mainfestModel.gender = 'female';
              setState(() {});
            }),
        SizedBox(
          width: 100,
          child: Text(
            'Female',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        GRawCheckbox(
            value: mainfestModel.gender == 'male',
            onChange: (value) {
              mainfestModel.gender = 'male';
              setState(() {});
            }),
        SizedBox(
          width: 100,
          child: Text(
            'Male',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
    var appbar = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _selectRole == -1
            ? const SizedBox.shrink()
            : Image.network(_voices[_selectRole].avatar, width: 60, height: 60),
        GSelectButton<String>(
            titleBuilder: (value) {
              return value!;
            },
            value: _selectRole == -1 ? '选择角色' : _voices[_selectRole].name,
            onChanged: (value) {
              mainfestModel.name = value;
              setState(() {});
            },
            items: _voices.map((e) => e.name).toList()),
        const SizedBox(
          width: 20,
        ),
        GSelectButton<Language>(
            titleBuilder: (value) {
              return UserMap.language(value!);
            },
            value: _selectLan,
            onChanged: (value) {
              _selectLan = value;
              mainfestModel.locale = value.toString();
              setState(() {});
            },
            items: Language.values),
        const SizedBox(
          width: 20,
        ),
        gender,
        GRawButton(
            width: 100,
            color: Colors.green.shade50,
            onPressed: () {},
            shape: const StadiumBorder(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('生成'),
              ],
            )),
      ],
    );
    var displayName = Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(
              'Display Name',
              style: Theme.of(context).textTheme.titleSmall,
            )),
        SizedBox(
          width: inputWidth,
          child: GRawInput(
            onChanged: (text) {
              mainfestModel.displayName = text;
            },
          ),
        ),
      ],
    );
    var description = Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.titleSmall,
            )),
        SizedBox(
          width: inputWidth,
          child: GRawInput(
            onChanged: (text) {
              mainfestModel.description = text;
            },
          ),
        ),
      ],
    );
    var version = Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(
              'Version',
              style: Theme.of(context).textTheme.titleSmall,
            )),
        SizedBox(
          width: inputWidth,
          child: GRawInput(onChanged: (text) {
            mainfestModel.version = text;
          }),
        ),
      ],
    );
    var author = Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(
              'Author',
              style: Theme.of(context).textTheme.titleSmall,
            )),
        SizedBox(
          width: inputWidth,
          child: GRawInput(onChanged: (text) {
            mainfestModel.author = text;
          }),
        ),
      ],
    );
    var languages = Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(
              'Program Languages',
              style: Theme.of(context).textTheme.titleSmall,
            )),
        SizedBox(
          height: 30,
          width: 200,
          child: GRawInput(
            controller: _programLanEditor,
            onEditingComplete: () {
              mainfestModel.languages.add(_programLanEditor.text);
              setState(() {});
            },
            rounded: false,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
    var showLanguages = Row(
      children: [
        ...List.generate(
            mainfestModel.languages.length,
            (index) => GestureDetector(
                  onLongPress: () async {
                    var result = false;
                    result = await buildShowCupertinoDialog(context);
                    if (result) {
                      mainfestModel.languages.removeAt(index);
                      setState(() {});
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent.withOpacity(0.25)),
                      child: Text(
                        mainfestModel.languages[index],
                        style: Theme.of(context).textTheme.button,
                      )),
                )).sepWidget(
            separate: const SizedBox(
          width: 10,
        ))
      ],
    );
    return GScaffold(
        appBar: appbar,
        content: Center(
          child: ListView(
            padding: const EdgeInsets.all(10),
            controller: _scrollController,
            children: [
              displayName,
              const SizedBox(
                height: 10,
              ),
              description,
              const SizedBox(
                height: 10,
              ),
              version,
              const SizedBox(
                height: 10,
              ),
              author,
              const SizedBox(
                height: 10,
              ),
              languages,
              const SizedBox(
                height: 10,
              ),
              showLanguages,
              const SizedBox(
                height: 10,
              ),
              ...List
                  .generate(mainfestModel.contributes.length,
                      (index) => buildContribute(index)).sepWidget(
                  separate: const SizedBox(
                height: 20,
              )),
              const SizedBox(
                height: 20,
              ),
              GRawButton(
                  shape: const StadiumBorder(),
                  elevation: 0.5,
                  color: Colors.greenAccent.withOpacity(0.15),
                  onPressed: () {
                    mainfestModel.contributes.add(Contributes.init());
                    setState(() {});
                  },
                  child: Text(
                    '添加条目',
                    style: Theme.of(context).textTheme.button,
                  ))
            ],
          ),
        ));
  }

  Future<dynamic> buildShowCupertinoDialog(BuildContext context) {
    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            '是否删除？',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                '确定',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }

  Widget buildContribute(int cindex) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.amberAccent.withOpacity(0.15),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 200,
                child: GRawInput(
                  placeholder: '输入触发关键字',
                  controller: _editingController,
                  rounded: false,
                  onSubmitted: (text) {
                    mainfestModel.contributes[cindex].keywords
                        .add(_editingController.text);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    mainfestModel.contributes.removeAt(cindex);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: mainfestModel.contributes[cindex].keywords
                .map((e) => GestureDetector(
                      onLongPress: () async {
                        var result = false;
                        result = await buildShowCupertinoDialog(context);
                        if (result) {
                          mainfestModel.contributes[cindex].keywords.remove(e);
                          setState(() {});
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blueAccent.withOpacity(0.25)),
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.button,
                          )),
                    ))
                .toList()
                .sepWidget(
                    separate: const SizedBox(
                  width: 10,
                )),
          ),
          const SizedBox(height: 20),
          ...List.generate(mainfestModel.contributes[cindex].titles.length,
                  (index) => buildTitle(cindex, index))
              .sepWidget(separate: const SizedBox(height: 20)),
          const SizedBox(height: 20),
          GRawButton(
              onPressed: () {
                mainfestModel.contributes[cindex].titles.add('');
                setState(() {});
              },
              child: Text(
                '添加语音',
                style: Theme.of(context).textTheme.button,
              ))
        ],
      ),
    );
  }

  Row buildTitle(int cindex, int index) {
    return Row(
      children: [
        if (_selectRole != -1)
          GSelectButton<String>(
              value: _selectTitle(cindex, index) == -1
                  ? '选择字段'
                  : _voices[_selectRole]
                      .titles[_selectTitle(cindex, index)]
                      .text,
              onChanged: (value) {
                mainfestModel.contributes[cindex].titles[index] = value;
                mainfestModel.contributes[cindex].voices.add(
                    _voices[_selectRole]
                        .titles[_selectTitle(cindex, index)]
                        .voices[_selectLan.index]);

                setState(() {});
              },
              items: _voices[_selectRole].titles.map((e) => e.text).toList()),
        if (_selectRole != -1 && _selectTitle(cindex, index) != -1)
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 300,
                child: Text(
                  _voices[_selectRole]
                      .titles[_selectTitle(cindex, index)]
                      .content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () async {
                    await player.setUrl(_voices[_selectRole]
                        .titles[_selectTitle(cindex, index)]
                        .voices[_selectLan.index]);
                    await player.play();
                  },
                  icon: const Icon(Icons.volume_up)),
              IconButton(
                  onPressed: () {
                    mainfestModel.contributes[cindex].titles.removeAt(index);
                    mainfestModel.contributes[cindex].voices.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
      ],
    );
  }
}
