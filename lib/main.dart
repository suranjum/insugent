import 'package:flutter/material.dart';
import 'package:insugent/helpers/appsettings.dart';
import 'package:insugent/pages/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppSettings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppSettings.primaryColor,
        accentColor: AppSettings.accentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Ubuntu',
        appBarTheme: AppBarTheme(
            elevation: 1,
            centerTitle: true,
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            textTheme: TextTheme(
                headline6: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ))),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppSettings.primaryColor,
        accentColor: AppSettings.accentColor,
        fontFamily: 'Ubuntu',
        appBarTheme: AppBarTheme(
            elevation: 1,
            centerTitle: true,
            color: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            textTheme: TextTheme(
                headline6: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ))),
      ),
      home: App(),
    );
  }
}
