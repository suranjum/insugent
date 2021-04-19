import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insugent/constants.dart';
import 'package:insugent/pages/home.dart';
import 'package:insugent/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPreferences sharedPreferences;
  bool isAppLogged = false;

  getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool("isapplogged") ?? false;
      if (isAppLogged)
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage())));
      else
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login())));
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'res/insugent.png',
                  width: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  kAppName,
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
