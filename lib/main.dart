import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takvim/pages/lang_settings_page.dart';
import 'package:takvim/pages/mosque_settings_page.dart';
import 'pages/pages.dart';
import 'package:flutter_riverpod/all.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('pref');
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool langPrefSet = false;
  bool mosquePrefSet = false;
  @override
  void initState() {
    super.initState();
    final prefBox = Hive.box('pref');

    String appLang = prefBox.get('appLang');
    String prayerLang = prefBox.get('prayerLang');
    String mosque = prefBox.get('mosque');

    print('BOX main: $appLang $prayerLang $mosque');

    if (appLang != null && prayerLang != null) {
      langPrefSet = true;
    }
    if (mosque != null) {
      mosquePrefSet = true;
    }
  }

  String _getInitialRoute() {
    if (!langPrefSet) {
      return '/lang';
    } else if (!mosquePrefSet) {
      return '/mosque';
    } else {
      return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Takvim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _getInitialRoute(),
      routes: {
        '/home': (context) => HomePage(),
        '/lang': (context) => LangSettingsPage(),
        '/mosque': (context) => MosqueSettingsPage(),
      },
      home: SafeArea(child: HomePage()),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
