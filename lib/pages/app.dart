import 'package:flutter/material.dart';
import 'package:insugent/helpers/adaptive.dart';
import 'package:insugent/helpers/my_flutter_app_icons.dart';
import 'package:insugent/pages/brands_page.dart';
import 'package:insugent/pages/clients_page.dart';
import 'package:insugent/pages/dash_page.dart';
import 'package:insugent/pages/users_page.dart';

import '../constants.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.5),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  bottom: 5.0,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(LineIcons.brandingWatermark),
            title: Text('Brands'),
            onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new BrandsPage())),
          ),
          ListTile(
            leading: Icon(LineIcons.verifiedUser),
            title: Text('Users'),
            onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new UsersPage())),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(LineIcons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(LineIcons.group), label: 'Clients'),
      ],
      onTap: navigationTapped,
      currentIndex: _page,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      return Row(
        children: [
          _drawer(),
          const VerticalDivider(width: 0.5),
          Expanded(
              child: Scaffold(
            appBar: _appBar(),
            body: _body(),
            bottomNavigationBar: _bottomBar(),
          )),
        ],
      );
    } else {
      return Scaffold(
        appBar: _appBar(),
        drawer: _drawer(),
        body: _body(),
        bottomNavigationBar: _bottomBar(),
      );
    }
  }
}
