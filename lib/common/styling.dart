import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CustomTextFonts {
  static TextStyle title = TextStyle(fontSize: 20);
  static TextStyle contentText = TextStyle(fontSize: 18);
  static TextStyle contentTextItalic =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);
  static TextStyle contentTextBold =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static TextStyle mosqueListName =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);
  static TextStyle mosqueListOther =
      TextStyle(fontSize: 18, fontStyle: FontStyle.normal);

  static TextStyle prayerTimesMain =
      TextStyle(fontSize: 18, fontStyle: FontStyle.normal);
  static TextStyle prayerTimesMinor = TextStyle(
      fontSize: 16, fontStyle: FontStyle.italic, color: CustomColors.mainColor);
}

class CustomColors {
  static final Color mainColor = Colors.tealAccent[700];
  static final Color counterTimeColor = Colors.tealAccent[900];
  static final Color cityNameColor = Colors.teal[700];
  static final Color highlightColor = Color(0xffb2dfdb);
  static final Color highlightColorLighter = Color(0xffDEF4F3);
  static final Color highlightColorDarker = Color(0xff80BFBA);

  static final MaterialColor swatch = MaterialColor(
    0xFF00bfa5,
    <int, Color>{
      50: Color(0xFF00bfa5),
      100: Color(0xFF00bfa5),
      200: Color(0xFF00bfa5),
      300: Color(0xFF00bfa5),
      400: Color(0xFF00bfa5),
      500: Color(0xFF00bfa5),
      600: Color(0xFF00bfa5),
      700: Color(0xFF00bfa5),
      800: Color(0xFF00bfa5),
      900: Color(0xFF00bfa5),
    },
  );
}

class NewsLabelColors {
  static final color1 = Colors.red[300];
  static final color2 = Colors.green[300];
  static final color3 = Colors.blue[300];
  static final color4 = Colors.yellow[300];
  static final color5 = Colors.purple[300];
}

ThemeNotifier currentTheme = ThemeNotifier();

class ThemeNotifier with ChangeNotifier {
  static bool _isDark = false;

  void setThemeDark() {
    _isDark = true;
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme(Box pref) {
    _isDark = !_isDark;
    pref.put('theme', _isDark);
    notifyListeners();
  }
}

ThemeData buildLightThemeData() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    primaryColor: Colors.tealAccent[700],
    primarySwatch: CustomColors.swatch,
    canvasColor: Colors.grey[100],
    floatingActionButtonTheme: ThemeData.light()
        .floatingActionButtonTheme
        .copyWith(foregroundColor: Colors.white),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline2: TextStyle(
              fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
          headline1: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
          headline3: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
          headline4: TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
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
              fontSize: 18, fontStyle: FontStyle.normal, color: Colors.black),
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
        surface: Color(0xffb2dfdb),
        primary: Color(0xFF00bfa5),
        primaryVariant: Color(0xffb2dfdb),
        secondaryVariant: CustomColors.mainColor),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}

ThemeData buildDarkThemeData() {
  return ThemeData(
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
              fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
          headline1: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
          headline3: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          headline4: TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),
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
              fontSize: 18, fontStyle: FontStyle.normal, color: Colors.white),
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
  );
}
