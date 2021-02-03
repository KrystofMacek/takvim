import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:takvim/pages/lang_settings_page.dart';
import 'package:takvim/pages/mosque_detail_page.dart';
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
  bool darkTheme = false;
  @override
  void initState() {
    super.initState();
    final prefBox = Hive.box('pref');

    String appLang = prefBox.get('appLang');
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
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: 'TV'),
          ResponsiveBreakpoint.autoScale(3840, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Takvim',
      themeMode: currentTheme.currentTheme(),
      darkTheme: ThemeData(
        primaryColor: Color(0xFF283142),
        canvasColor: Color(0xFF09111F),
        primarySwatch: CustomColors.swatch,
        scaffoldBackgroundColor: Color(0xFF09111F),
        cardColor: Color(0xFF283142),
        floatingActionButtonTheme: ThemeData.light()
            .floatingActionButtonTheme
            .copyWith(foregroundColor: CustomColors.mainColor),
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline2: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              headline3: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              headline4: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              headline5: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Noto-Mono',
                  fontStyle: FontStyle.normal,
                  color: Colors.teal[800]),
              subtitle2: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF202020)),
              subtitle1: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
              bodyText1: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.normal,
              ),
              bodyText2: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[300],
              ),
            ),
        colorScheme: ColorScheme.dark(
          surface: Color(0xFF283142),
          primary: Color(0xFF283142),
          primaryVariant: Color(0xff80BFBA),
          secondaryVariant: Colors.grey[300],
        ),
        iconTheme: IconThemeData(
          color: CustomColors.mainColor,
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primaryColor: Colors.tealAccent[700],
        primarySwatch: CustomColors.swatch,
        canvasColor: Colors.grey[100],
        floatingActionButtonTheme: ThemeData.light()
            .floatingActionButtonTheme
            .copyWith(foregroundColor: Colors.white),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline2: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              headline3: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              headline4: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
              headline5: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Noto-Mono',
                  fontStyle: FontStyle.normal,
                  color: Colors.teal[800]),
              subtitle2: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: CustomColors.mainColor),
              subtitle1: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
              bodyText1: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.normal,
              ),
              bodyText2: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
        colorScheme: ColorScheme.light(
            primary: Color(0xFF00bfa5),
            primaryVariant: Color(0xffb2dfdb),
            secondaryVariant: CustomColors.mainColor),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      initialRoute: _getInitialRoute(),
      routes: {
        '/home': (context) => HomePage(),
        '/lang': (context) => LangSettingsPage(),
        '/mosque': (context) => MosqueSettingsPage(),
        '/mosqueDetail': (context) => MosqueDetailPage(),
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
