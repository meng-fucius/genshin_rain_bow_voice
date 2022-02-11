import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goose_ui/goose_ui.dart';
import 'package:provider/provider.dart';
import 'package:rain_bow_genshin_voices/providers/theme_manager.dart';

class KeyToolPage extends StatefulWidget {
  const KeyToolPage({Key? key}) : super(key: key);

  @override
  _KeyToolPageState createState() => _KeyToolPageState();
}

class _KeyToolPageState extends State<KeyToolPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return GScaffold(
        content: Center(
      child: Column(
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
    ));
  }
}
