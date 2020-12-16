import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:insugent/helpers/my_flutter_app_icons.dart';
import 'package:insugent/helpers/utility.dart';
import 'package:insugent/models/users_model.dart';
import 'package:insugent/providers/users_api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController<List<User>> _userController;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _expiredateController = new TextEditingController();

  bool isDesktop = false;
  String currentUserId = "";
  String currentPassword = "";
  bool isWeb = false;

  loadUsers() async {
    Map<String, String> post = {
      'postdata': jsonEncode({'qry': '', 'sort': 'userfullname', 'pn': '0'})
    };
    UsersApiProvider.fetchUsers(post).then((res) async {
      _userController.add(res);
      return res;
    });
  }

  void _saveUser() async {
    if (_nameController.text.isEmpty) {
      return;
    } else {
      Map<String, String> post = {
        'postdata': jsonEncode({
          'rs': 'zepj6894',
          'mode': (currentUserId.isEmpty ? '0' : '1'),
          'id': currentUserId,
          'fullname': _nameController.text,
          'mobile': _mobileController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'image': '',
          'profile': '',
          'expiredate': _expiredateController.text,
          'password': currentPassword
        })
      };
      UsersApiProvider.updateUser(post).then((value) {
        if (value) {
          Navigator.pop(context);
          loadUsers();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Updated successfully!'),
            duration: Duration(seconds: 3),
          ));
        }
      });
    }
  }

  void _deleteUser(String _userId) async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'rs': 'zepj6894',
        'id': _userId,
      })
    };
    UsersApiProvider.deleteUser(post).then((value) {
      if (value) {
        Navigator.pop(context);
        loadUsers();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Deleted successfully!'),
          duration: Duration(seconds: 3),
        ));
      }
    });
  }

  @override
  void initState() {
    _userController = new StreamController();
    loadUsers();
    super.initState();
    print(Utility.passCode());
  }

  @override
  Widget build(BuildContext context) {
    isWeb = kIsWeb;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _userController.stream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var user = snapshot.data[index];
                return ListTile(
                  onTap: () => _showUser(context, user),
                  leading: CircleAvatar(
                    child: Text(Utility.getInitials(user.userFullName)),
                  ),
                  title: Text(user.userFullName),
                  subtitle: Text(
                    user.userAddress,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text('No data.'),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.add),
        onPressed: () {
          setState(() {
            currentUserId = "";
            _nameController.text = '';
            _mobileController.text = "";
            _emailController.text = "";
            _addressController.text = "";
            _expiredateController.text = "";
            currentPassword = Utility.passCode();
          });
          _showEdit(context);
        },
      ),
    );
  }

  _showUser(BuildContext context, User _user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: isWeb ? 15.0 : 40.0, horizontal: 15.0),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(LineIcons.clear),
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  FlatButton(
                    child: Text('Edit'),
                    onPressed: () {
                      setState(() {
                        currentUserId = _user.userId;
                        _nameController.text = _user.userFullName;
                        _mobileController.text = _user.userMobile;
                        _emailController.text = _user.userEmail;
                        _addressController.text = _user.userAddress;
                        _expiredateController.text = _user.userExpireDate;
                        currentPassword = _user.userPassword;
                      });
                      Navigator.pop(context);
                      _showEdit(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Delete'),
                    onPressed: () => _confirmDelete(_user),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(LineIcons.person),
                title: Text(_user.userFullName),
                subtitle: Text('Name'),
              ),
              ListTile(
                leading: Icon(LineIcons.place),
                title: Text(
                  _user.userAddress,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Address'),
              ),
              ListTile(
                leading: Icon(LineIcons.phoneAndroid),
                title: Text(_user.userMobile),
                subtitle: Text('Mobile'),
              ),
              ListTile(
                leading: Icon(LineIcons.email),
                title: Text(_user.userEmail),
                subtitle: Text('E-Mail'),
              ),
              Visibility(
                visible: _user.userProfile.isNotEmpty,
                child: ListTile(
                  leading: Icon(LineIcons.info),
                  title: Text(_user.userProfile),
                ),
              ),
              ListTile(
                leading: Icon(LineIcons.accessTime),
                title: Text(_user.userExpireDate),
                subtitle: Text('Expires on'),
              ),
              Visibility(
                visible: !isWeb,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    child: Text('Send Passcode via SMS'),
                    onPressed: () {
                      _launchURL('sms:' +
                          (_user.userMobile.indexOf('+') < 0 ? '+91' : '') +
                          _user.userMobile +
                          '?body=' +
                          'The passcode for your Insugent login is ${_user.userPassword}');
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(User _user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteUser(_user.userId);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('No'))
            ],
          );
        });
  }

  void _showEdit(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (context) {
        return new Scaffold(
          appBar: AppBar(
            title: Text('Edit'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      suffixIcon: Icon(LineIcons.person),
                    ),
                    maxLength: 50,
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _addressController,
                    maxLength: 250,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        suffixIcon: Icon(LineIcons.locationCity)),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      suffixIcon: Icon(LineIcons.phoneAndroid),
                    ),
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'E-Mail', suffixIcon: Icon(LineIcons.email)),
                    controller: _emailController,
                    maxLength: 250,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _expiredateController,
                    maxLength: 15,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Expire Date',
                        suffixIcon: Icon(LineIcons.calendarToday)),
                    onTap: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null)
                        _expiredateController.text =
                            date.toString().substring(0, 10);
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                    icon: Icon(LineIcons.check),
                    label: Text('Save'),
                    onPressed: () => _saveUser(),
                  ),
                  FlatButton.icon(
                    icon: Icon(LineIcons.close),
                    label: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
