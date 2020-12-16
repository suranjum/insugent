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
    inputDecorationTheme: inputDecorationTheme(),
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
    inputDecorationTheme: inputDecorationTheme(),
    iconTheme: IconThemeData(color: Colors.blue),
  );
}

InputDecorationTheme inputDecorationTheme() {
  // OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(15),
  //   borderSide: BorderSide(color: kTextColor),
  //   gapPadding: 10,
  // );
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    // enabledBorder: outlineInputBorder,
    // focusedBorder: outlineInputBorder,
    // border: outlineInputBorder,
    filled: true,
  );
}
