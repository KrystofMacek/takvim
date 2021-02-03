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
