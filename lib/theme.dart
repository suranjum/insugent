import 'package:flutter/material.dart';
import 'package:insugent/constants.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        color: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
          fontSize: 22,
          color: Colors.black,
        ))),
    iconTheme: IconThemeData(color: Colors.blue),
  );
}

ThemeData themeDark() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
        elevation: 1,
        centerTitle: true,
        color: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ))),
    iconTheme: IconThemeData(color: Colors.blue),
  );
}
