import 'package:flutter/material.dart';

class CustomTextFonts {
  static final TextStyle title = TextStyle(fontSize: 20);
  static final TextStyle contentText = TextStyle(fontSize: 18);
  static final TextStyle contentTextItalic =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);
  static final TextStyle contentTextBold =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static final TextStyle mosqueListName =
      TextStyle(fontSize: 16, fontStyle: FontStyle.italic);
  static final TextStyle mosqueListOther =
      TextStyle(fontSize: 16, fontStyle: FontStyle.normal);

  static final TextStyle prayerTimesMain = TextStyle(
      fontSize: 20, fontStyle: FontStyle.normal, color: Colors.teal[700]);
  static final TextStyle prayerTimesMinor = TextStyle(
      fontSize: 16, fontStyle: FontStyle.italic, color: Colors.teal[200]);

  static final TextStyle notesFont = TextStyle(
      fontSize: 16, fontStyle: FontStyle.normal, color: Colors.amber[700]);

  static final TextStyle appBarTextItalic =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white);
  static final TextStyle appBarTextNormal =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
}

class CustomColors {
  static final Color mainColor = Colors.tealAccent[700];
  static final Color cityNameColor = Colors.teal[700];

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
