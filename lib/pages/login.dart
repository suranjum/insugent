import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:insugent/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount _currentUser;
  SharedPreferences sharedPreferences;

  bool isLoading = false;
  String userId = "";

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleGetContact() async {
    setState(() {
      isLoading = true;
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registering user account..."),
        duration: Duration(seconds: 3),
      ));
      await Firebase.initializeApp();
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await FirebaseFirestore.instance
          .collection('users')
          .where('useremail', isEqualTo: _currentUser.email)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          var uuid = Uuid();
          setState(() {
            userId = uuid.v1();
          });
          users.add({
            'userid': userId,
            'useremail': _currentUser.email,
            'userdisplayname': _currentUser.displayName
          }).then((value) => print('User Added'));
        } else {
          print('Welcome back!');
        }
        _validateGoogleUser();
      });
    }
  }

  Future _validateGoogleUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setBool("isapplogged", true);
      sharedPreferences.setString("userid", userId);
      sharedPreferences.setString("useremail", _currentUser.email);
      sharedPreferences.setString("userdisplayname", _currentUser.displayName);
      sharedPreferences.setString("userimage", _currentUser.photoUrl);
      sharedPreferences.commit();
    });
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage()),
        (Route<dynamic> route) => false);
  }

  Future<void> getBrands() async {
    print(await rootBundle.loadString("res/brands.json"));
  }

  @override
  void initState() {
    super.initState();
    getBrands();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print(_currentUser.displayName);
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
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
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: OutlinedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'res/google.png',
                          width: 25,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sign-In with Google',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => _handleSignIn(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
