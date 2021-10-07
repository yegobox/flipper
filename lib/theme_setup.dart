import 'package:flutter/material.dart';

List<ThemeData> getThemes() {
  return [
    ThemeData(
      primaryColor: Colors.blueAccent,
      // set canvasColor to transparent when working on dark mode.
      // canvasColor: Colors.transparent,
      // primaryColorDark: Color(0xff262833),
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.white,
    ),
    // ThemeData(backgroundColor: Colors.white, accentColor: Colors.green),
    // ThemeData(backgroundColor: Colors.purple, accentColor: Colors.green),
    // ThemeData(backgroundColor: Colors.black, accentColor: Colors.red),
    // ThemeData(backgroundColor: Colors.red, accentColor: Colors.blue),
  ];
}
