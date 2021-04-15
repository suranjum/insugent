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
    });
  }

  Widget _appBar() {
    return AppBar(
      title: Text(kAppName),
      centerTitle: true,
    );
  }

  Widget _body() {
    return new PageView(
      children: [
        new DashPage(),
        new ClientsPage(),
      ],
      onPageChanged: onPageChanged,
      controller: _pageController,
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userDisplayName),
            accountEmail: Text(userEmail),
            currentAccountPicture: userImage.isNotEmpty
                ? ClipRRect(
                    child: Image.network(
                      userImage,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  )
                : CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.person_2),
            title: Text('Clients'),
            onTap: () {},
          ),
        ],
      ),
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
    getPrefs();
    _pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: _body(),
      bottomNavigationBar: _bottomBar(),
    );
  }
}
