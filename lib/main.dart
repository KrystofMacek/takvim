import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takvim/pages/lang_settings_page.dart';
import 'package:takvim/pages/mosque_settings_page.dart';
import 'pages/pages.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/services.dart';
import './common/styling.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox('pref');
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);

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
  bool firstOpen = false;
  @override
  void initState() {
    super.initState();
    final prefBox = Hive.box('pref');

    String appLang = prefBox.get('appLang');
    // String prayerLang = prefBox.get('prayerLang');
    String mosque = prefBox.get('mosque');

    print('BOX main: $appLang $mosque');

    if (appLang == null && mosque == null) {
      print('BOX main default: $appLang $mosque');
      prefBox.put('mosque', '1001');
      prefBox.put('appLang', '101');
      firstOpen = true;
    }
    print('BOX main: $firstOpen');
    prefBox.put('firstOpen', firstOpen);
  }

  String _getInitialRoute() {
    if (firstOpen) {
      return '/lang';
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
          primaryColor: Colors.tealAccent[700],
          primarySwatch: CustomColors.swatch,
          colorScheme: ColorScheme.light(primary: Color(0xFF00bfa5))),
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
