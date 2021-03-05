import 'dart:io';

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
import 'package:takvim/pages/mosque_settings_page.dart';
import 'package:takvim/pages/news/news_mosques_page.dart';
import 'package:takvim/pages/news/news_page.dart';
import 'package:takvim/pages/subscribtion_page.dart';
import 'package:url_launcher/url_launcher.dart';
import './pages/compass_page.dart';
import './data/models/subsTopic.dart';
import './common/styling.dart';
import 'pages/pages.dart';
import './pages/contact.dart';
import './pages/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takvim/providers/language_page/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  Hive.registerAdapter(SubsTopicAdapter());
  await Hive.openBox('pref');
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  FirebaseMessaging fcm = FirebaseMessaging();
  await _fcmPermission(fcm);

  fcm.configure(
    onMessage: (message) async {},
    onLaunch: (message) async {
      String url = '';
      if (Platform.isIOS) {
        url = message['URL'];
      }
      if (Platform.isAndroid) {
        url = message['data']['URL'];
      }
      print(url);

      if (await canLaunch('http://$url')) {
        await launch(
          'http://$url',
          forceSafariVC: false,
        );
      } else {
        throw 'Could not launch $url';
      }
    },
    onResume: (message) async {
      String url = '';
      if (Platform.isIOS) {
        url = message['URL'];
      }
      if (Platform.isAndroid) {
        url = message['data']['URL'];
      }
      print(url);

      if (await canLaunch('http://$url')) {
        await launch(
          'http://$url',
          forceSafariVC: false,
        );
      } else {
        throw 'Could not launch $url';
      }
    },
    onBackgroundMessage: Platform.isAndroid ? myBackgroundMessageHandler : null,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> message) async {}

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
    // refresh languages
    context.read(languagePackController).updateAppLanguage();

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
        // '/mosqueDetail': (context) => MosqueDetailPage(),
        '/sub': (context) => SubscribtionPage(),
        '/newsPage': (context) => NewsPage(),
        '/newsMosquesPage': (context) => NewsMosquesPage(),
        '/compass': (context) => CompassPage(),
        '/map': (context) => MapPage(),
        '/contact': (context) => ContactPage(),
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
