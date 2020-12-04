import 'package:flutter/material.dart';
import 'package:insugent/constants.dart';
import 'package:insugent/pages/app.dart';
import 'package:insugent/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: theme(),
      darkTheme: themeDark(),
      home: App(),
    );
  }
}
