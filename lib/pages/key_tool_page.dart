import 'package:flutter/material.dart';
import 'package:goose_ui/goose_ui.dart';
import 'package:provider/provider.dart';
import 'package:rain_bow_genshin_voices/models/role_model.dart';
import 'package:rain_bow_genshin_voices/providers/role_data.dart';
import 'package:rain_bow_genshin_voices/providers/theme_manager.dart';
import 'package:rain_bow_genshin_voices/tools/html/voice_fetch.dart';

class KeyToolPage extends StatefulWidget {
  const KeyToolPage({Key? key}) : super(key: key);

  @override
  _KeyToolPageState createState() => _KeyToolPageState();
}

class _KeyToolPageState extends State<KeyToolPage> {
  bool edit = false;
  final TextEditingController _zhNameController = TextEditingController();
  final TextEditingController _enNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _zhNameController.dispose();
    _enNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final roleData = Provider.of<RoleData>(context);
    return GScaffold(
        content: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTile(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '深色模式',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GSwitch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          themeManager.changeTheme(value, context);
                          setState(() {});
                        })
                  ],
                ),
                backColor: Colors.white),
            const SizedBox(
              height: 10,
            ),
            buildTile(
              backColor: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  edit
                      ? Column(
                          children: [
                            SizedBox(
                                width: 200,
                                child: GRawInput(
                                  controller: _zhNameController,
                                )),
                            SizedBox(
                                width: 200,
                                child: GRawInput(
                                  controller: _enNameController,
                                ))
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '全部角色',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GSelectButton(
                                value: '',
                                onChanged: (value) {
                                  setState(() {});
                                },
                                items: roleData.roles
                                    .map((e) => e.zhName)
                                    .toList()),
                          ],
                        ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GRawButton(
                        onPressed: () async {
                          if (edit) {
                            if (_enNameController.text.isEmpty ||
                                _zhNameController.text.isEmpty) {
                              edit = !edit;
                              setState(() {});
                              return;
                            }
                            roleData.addRole(Role(
                                zhName: _zhNameController.text,
                                enName: _enNameController.text));
                            await roleData.updateVoice();
                          }
                          edit = !edit;
                          setState(() {});
                        },
                        color: edit
                            ? Colors.amberAccent.withOpacity(0.25)
                            : Colors.blueAccent.withOpacity(0.25),
                        child: Text(
                          edit ? '添加' : '添加新角色',
                          style: Theme.of(context).textTheme.button,
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GRawButton(
              width: 500,
              height: 40,
              elevation: 0.8,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black.withOpacity(0.25)),
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () async {
                // await roleData.updateAllVoice();
                VoiceFetch().getVoices();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '更新所有角色语音',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget buildTile({required Widget child, Color? backColor}) {
    return Container(
      width: 500,
      constraints: const BoxConstraints(minHeight: 40),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(blurRadius: 0.8, spreadRadius: 0),
          ]),
      child: child,
    );
  }
}
