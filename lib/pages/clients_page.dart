import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:insugent/helpers/my_flutter_app_icons.dart';
import 'package:insugent/models/clients_model.dart';
import 'package:insugent/providers/clients_api_provider.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController<List<Client>> _clientController;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _remarksController = new TextEditingController();

  bool isDesktop = false;
  bool isWeb = false;
  String currentClientId = "";

  loadClients() async {
    Map<String, String> post = {
      'postdata': jsonEncode({'qry': '', 'sort': 'client_name', 'pn': '0'})
    };
    ClientsApiProvider.fetchClients(post).then((res) async {
      _clientController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    _clientController = new StreamController();
    loadClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isWeb = kIsWeb;

    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<List<Client>>(
        stream: _clientController.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var client = snapshot.data[index];
                return ListTile(
                  onTap: () => _showClient(context, client),
                  title: Text(client.clientName),
                  subtitle: Text(
                    client.clientAddress,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
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
        tooltip: 'New',
        onPressed: () {
          _showEdit(context);
        },
      ),
    );
  }

  void _showClient(BuildContext context, Client _client) {
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
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text('Edit'),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text('De-ctvate'),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text('Delete'),
                    onPressed: () {},
                  ),
                ],
              ),
              ListTile(
                leading: Icon(LineIcons.person),
                title: Text(_client.clientName),
                subtitle: Text('Name'),
              ),
              ListTile(
                leading: Icon(LineIcons.myLocation),
                title: Text(
                  _client.clientAddress,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Address'),
              ),
              ListTile(
                leading: Icon(LineIcons.phoneAndroid),
                title: Text(_client.clientMobile),
                subtitle: Text('Mobile'),
              ),
              ListTile(
                leading: Icon(LineIcons.email),
                title: Text(_client.clientEmail),
                subtitle: Text('E-Mail'),
              ),
              Visibility(
                visible: _client.clientRemarks.isNotEmpty,
                child: ListTile(
                  leading: Icon(LineIcons.info),
                  title: Text(_client.clientRemarks),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEdit(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (context) {
        return new Scaffold(
          appBar: AppBar(
            title: Text('Edit'),
            actions: [
              FlatButton.icon(
                icon: Icon(LineIcons.check),
                label: Text('Save'),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _addressController,
                    maxLength: 250,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _mobileController,
                    maxLength: 20,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _emailController,
                    maxLength: 250,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _remarksController,
                    maxLength: 250,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
