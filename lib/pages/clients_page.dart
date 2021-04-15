import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insugent/helpers/utility.dart';

class ClientsPage extends StatefulWidget {
  final String userId;

  ClientsPage({this.userId});

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _remarksController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  bool isDesktop = false;
  bool isWeb = false;
  String currentClientId = "";

  initFirestore() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('clients');

    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }
          QuerySnapshot querySnapshot = stream.data;
          return ListView.builder(
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _showClient(context, querySnapshot.docs[index]),
                  leading: CircleAvatar(
                    child: Text(Utility.getInitials(
                        querySnapshot.docs[index]['client_name'])),
                  ),
                  title: Text(querySnapshot.docs[index]['client_name']),
                  subtitle: Text(querySnapshot.docs[index]['client_mobile']),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.plus),
        tooltip: 'New',
        onPressed: () {
          _showEdit(context);
        },
      ),
    );
  }

  void _showClient(BuildContext context, DocumentSnapshot doc) {
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
                    icon: Icon(CupertinoIcons.clear),
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text('Edit'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Delete'),
                    onPressed: () {},
                  ),
                ],
              ),
              ListTile(
                leading: Icon(CupertinoIcons.person),
                title: Text(doc['client_name']),
                subtitle: Text('Name'),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.location),
                title: Text(
                  doc['client_address'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Address'),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.device_phone_portrait),
                title: Text(doc['client_mobile']),
                subtitle: Text('Mobile'),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.mail),
                title: Text(doc['client_email']),
                subtitle: Text('E-Mail'),
              ),
              Visibility(
                visible: doc['client_remarks'].isNotEmpty,
                child: ListTile(
                  leading: Icon(CupertinoIcons.info),
                  title: Text(doc['client_remarks']),
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
              TextButton.icon(
                icon: Icon(CupertinoIcons.check_mark),
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
                    controller: _dobController,
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
