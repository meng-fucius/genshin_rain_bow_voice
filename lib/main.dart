import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goose_ui/goose_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenshinVoices',
      theme: ThemeData.light(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<GAppMenuItem> _menus = [
    const GAppMenuItem(
        icon: CupertinoIcons.volume_up, title: '语音', children: []),
    const GAppMenuItem(icon: CupertinoIcons.selection_pin_in_out, title: '选项'),
  ];

  @override
  Widget build(BuildContext context) {
    return GScaffold(
        appTitleBar: const GAppBar(),
        drawer: GAppMenu(
            onPressed: (item) async {
              AssetBundle bundle = DefaultAssetBundle.of(context);
              String data = await bundle.loadString('voice.json');
              print(data);
              _currentIndex = _menus.indexOf(item);
              setState(() {});
            },
            children: _menus),
        content: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return SharedAxisTransition(
              child: child,
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
            );
          },
          child: [Text('111'), Text('222')][_currentIndex],
        ));
  }
}
