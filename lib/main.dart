import 'package:flutter/material.dart';
import 'package:insugent/constants.dart';
import 'package:insugent/pages/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kPrimaryColor,
        accentColor: kAccentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      ),
      darkTheme: ThemeData(
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
      ),
      home: App(),
    );
  }
}
