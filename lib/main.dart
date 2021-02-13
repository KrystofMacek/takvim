import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:takvim/pages/lang_settings_page.dart';
import 'package:takvim/pages/mosque_detail_page.dart';
import 'package:takvim/pages/mosque_settings_page.dart';
import 'package:takvim/pages/news/news_mosques_page.dart';
import 'package:takvim/pages/news/news_page.dart';
import 'package:takvim/pages/subscribtion_page.dart';

import './common/styling.dart';
import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox('pref');
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  FirebaseMessaging fcm = FirebaseMessaging();
  await _fcmPermission(fcm);
  fcm.configure(
    onMessage: (message) async {
      print('onMessage $message');
    },
    onLaunch: (message) async {
      print('onLaunch $message');
    },
    onResume: (message) async {
      print('onResume $message');
    },
    onBackgroundMessage: myBackgroundMessageHandler,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    print('myBackgroundMessageHandler contains data key $message');
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    print('myBackgroundMessageHandler contains notification key $message');
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

Future<void> _fcmPermission(FirebaseMessaging fcm) async {
  await fcm.requestNotificationPermissions();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool firstOpen = false;
  bool darkTheme = false;
  @override
  void initState() {
    super.initState();
    final prefBox = Hive.box('pref');

    final String appLang = prefBox.get('appLang');
    String mosque = prefBox.get('mosque');

    currentTheme.addListener(() {
      setState(() {});
    });
    darkTheme = prefBox.get('theme');
    if (darkTheme == null) {
      darkTheme = false;
      prefBox.put('theme', false);
    } else if (darkTheme) {
      currentTheme.setThemeDark();
    }

    if (appLang == null && mosque == null) {
      prefBox.put('mosque', '1001');
      prefBox.put('appLang', '101');
      firstOpen = true;
    }
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
      builder: (context, child) => ResponsiveWrapper.builder(
        ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        ),
        maxWidth: double.infinity,
        minWidth: 480,
        defaultScale: true,
        defaultScaleFactor: 1.2,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: 'TV'),
          const ResponsiveBreakpoint.autoScale(3840, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Takvim',
      themeMode: currentTheme.currentTheme(),
      darkTheme: buildDarkThemeData(),
      theme: buildLightThemeData(),
      initialRoute: _getInitialRoute(),
      routes: {
        '/home': (context) => HomePage(),
        '/lang': (context) => LangSettingsPage(),
        '/mosque': (context) => MosqueSettingsPage(),
        '/mosqueDetail': (context) => MosqueDetailPage(),
        '/sub': (context) => SubscribtionPage(),
        '/newsPage': (context) => NewsPage(),
        '/newsMosquesPage': (context) => NewsMosquesPage(),
      },
      home: HomePage(),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
