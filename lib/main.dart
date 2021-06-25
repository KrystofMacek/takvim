import 'dart:io';

import 'package:MyMosq/pages/home_page.dart';
import 'package:MyMosq/pages/news/mosques_sub_page.dart';
import 'package:MyMosq/pages/news/posts_sub_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:MyMosq/pages/lang_settings_page.dart';
import 'package:MyMosq/pages/mosque_settings_page.dart';
import 'package:MyMosq/pages/notification_config_page.dart';
import 'package:MyMosq/pages/subscribtion_page.dart';
import 'package:MyMosq/providers/common/notification_provider.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import './pages/compass_page.dart';
import './data/models/subsTopic.dart';
import './common/styling.dart';
import './pages/contact.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // initialize local storage db
  await Hive.initFlutter();
  Hive.registerAdapter(SubsTopicAdapter());
  // initialize db boxes
  await Hive.openBox('pref');
  await Hive.openBox('notificationConfig');
  // initialize firebase
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  FirebaseMessaging fcm = FirebaseMessaging();
  await _fcmPermission(fcm);

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

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

      if (await canLaunch('http://$url?integratedView=true')) {
        await launch(
          'http://$url?integratedView=true',
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

      if (await canLaunch('http://$url?integratedView=true')) {
        await launch(
          'http://$url?integratedView=true',
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
    //get user preferences
    final prefBox = Hive.box('pref');

    // get values from user preferences
    final String appLang = prefBox.get('appLang');
    final String mosque = prefBox.get('mosque');

    // setup theme changing
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

    // initialize mosque and applang ids if empty
    if (appLang == null && mosque == null) {
      prefBox.put('mosque', '1001');
      prefBox.put('appLang', '101');
      firstOpen = true;
    }
    // set the current state with initialized values
    context.read(selectedMosque).updateSelectedMosque(mosque);
    // autosub if necessary
    context.read(currentSubsListProvider).autoSubscribe(mosque ?? '1001');
    // save info about first open
    prefBox.put('firstOpen', firstOpen);
    // prayer time notifications initialized
    context.read(notificationProvider).initialize(context);
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
      title: 'MyMosq',
      themeMode: currentTheme.currentTheme(),
      darkTheme: buildDarkThemeData(),
      theme: buildLightThemeData(),
      initialRoute: _getInitialRoute(),
      routes: {
        '/home': (context) => HomePage(),
        '/lang': (context) => LangSettingsPage(),
        '/mosque': (context) => MosqueSettingsPage(),
        '/sub': (context) => SubscribtionPage(),
        '/newsPage': (context) => NewsPage(),
        '/newsMosquesPage': (context) => NewsMosquesPage(),
        '/compass': (context) => CompassPage(),
        '/contact': (context) => ContactPage(),
        '/notificationConfig': (context) => NotificationConfigPage(),
      },
      // home: HomePage(),
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
