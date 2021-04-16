import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insugent/pages/clients_page.dart';
import 'package:insugent/pages/dash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  String userDisplayName = "Unknown";
  String userEmail = "unknown@domain.com";
  String userImage = "";
  String userId = "";

  bool isDesktop = false;
  PageController _pageController;
  int _page = 0;

  initFirestore() async {
    await Firebase.initializeApp();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString("userid");
      userDisplayName = sharedPreferences.getString("userdisplayname");
      userEmail = sharedPreferences.getString("useremail");
      userImage = sharedPreferences.getString("userimage");
      print(userId);
    });
  }

  void showAccounts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * .4,
          margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: Card(
            child: ListView(
              children: [
                ListTile(
                  leading: userImage.isNotEmpty
                      ? ClipRRect(
                          child: Image.network(
                            userImage,
                            width: 50,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        )
                      : CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                  title: Text(userDisplayName),
                  subtitle: Text(userEmail),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red,
                    child: Icon(CupertinoIcons.wrench),
                  ),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue,
                    child: Icon(CupertinoIcons.checkmark_shield),
                  ),
                  title: Text('Privacy Policy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey,
                    child: Icon(CupertinoIcons.info),
                  ),
                  title: Text('About'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body() {
    return new PageView(
      children: [
        new DashPage(),
        new ClientsPage(
          userId: userId,
        ),
      ],
      onPageChanged: onPageChanged,
      controller: _pageController,
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2), label: 'Clients'),
      ],
      onTap: navigationTapped,
      currentIndex: _page,
    );
  }

  @override
  void initState() {
    super.initState();
    initFirestore();
    getPrefs();
    _pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kAppName,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        actions: [
          userImage.isNotEmpty
              ? IconButton(
                  icon: ClipRRect(
                    child: Image.network(
                      userImage,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onPressed: () => showAccounts(context),
                )
              : CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
        ],
      ),
      body: _body(),
      bottomNavigationBar: _bottomBar(),
    );
  }
}
