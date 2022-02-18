import 'package:animations/animations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goose_ui/goose_ui.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:provider/provider.dart';
import 'package:rain_bow_genshin_voices/pages/key_tool_page.dart';
import 'package:rain_bow_genshin_voices/pages/voice_page.dart';
import 'package:rain_bow_genshin_voices/providers/role_data.dart';
import 'package:rain_bow_genshin_voices/providers/theme_manager.dart';
import 'package:rain_bow_genshin_voices/tools/hive_util.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  hotKeyManager.unregisterAll();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    // Hide window title bar
    // await windowManager.setTitleBarStyle('hidden');
    await windowManager.setSize(const Size(1080, 720));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  await HiveUtil.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeManager()),
      ChangeNotifierProvider(create: (context) => RoleData()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenshinVoices',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: Provider.of<ThemeManager>(context).themeData,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  int _currentIndex = 1;

  final List<GAppMenuItem> _menus = [
    GAppMenuItem(
        icon: CupertinoIcons.volume_up, title: (context) => '语音', children: []),
    GAppMenuItem(
        icon: CupertinoIcons.selection_pin_in_out, title: (context) => '选项'),
  ];

  @override
  void onWindowFocus() {
    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () async {
      Provider.of<RoleData>(context, listen: false).init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GScaffold(
        appTitleBar: const GAppBar(),
        drawer: GAppMenu(
            onPressed: (item) async {
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
          child: [const VoicePage(), const KeyToolPage()][_currentIndex],
        ));
  }
}
