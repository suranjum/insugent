import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insugent/helpers/utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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

  @override
  void initState() {
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
                DocumentSnapshot _doc = querySnapshot.docs[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      currentClientId = _doc.id;
                    });
                    _showClient(context, _doc);
                  },
                  leading: CircleAvatar(
                    child: Text(Utility.getInitials(_doc['client_name'])),
                  ),
                  title: Text(_doc['client_name']),
                  subtitle: Text(_doc['client_mobile']),
                  trailing: (_doc['client_mobile'].toString().isNotEmpty
                      ? IconButton(
                          icon: Icon(CupertinoIcons.phone),
                          onPressed: () => _launchURL(_doc['client_mobile']),
                        )
                      : Container()),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.plus),
        tooltip: 'New',
        onPressed: () {
          setState(() {
            currentClientId = "";
          });
          _showEdit(context, null);
        },
      ),
    );
  }

  void _showClient(BuildContext context, DocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Card(
          child: Container(
            height: MediaQuery.of(context).size.height * .6,
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Stack(
              children: [
                ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey,
                        child: Icon(CupertinoIcons.person),
                      ),
                      title: Text(doc['client_name']),
                      subtitle: Text('Name'),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey,
                        child: Icon(CupertinoIcons.location),
                      ),
                      title: Text(
                        doc['client_address'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Address'),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey,
                        child: Icon(CupertinoIcons.device_phone_portrait),
                      ),
                      title: Text(doc['client_mobile']),
                      subtitle: Text('Mobile'),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey,
                        child: Icon(CupertinoIcons.mail),
                      ),
                      title: Text(doc['client_email']),
                      subtitle: Text('E-Mail'),
                    ),
                    Visibility(
                      visible: doc['client_remarks'].isNotEmpty,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey,
                          child: Icon(CupertinoIcons.info),
                        ),
                        title: Text(doc['client_remarks']),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text('Edit'),
                        onPressed: () {
                          Navigator.pop(context);
                          _showEdit(context, doc);
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteClient(doc.id);
                        },
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEdit(BuildContext context, DocumentSnapshot doc) {
    if (doc != null) {
      _nameController.text = doc['client_name'];
      _addressController.text = doc['client_address'];
      _mobileController.text = doc['client_mobile'];
      _emailController.text = doc['client_email'];
      _dobController.text = doc['client_dob'];
      _remarksController.text = doc['client_remarks'];
    } else {
      _nameController.text = "";
      _addressController.text = "";
      _mobileController.text = "";
      _emailController.text = "";
      _dobController.text = "";
      _remarksController.text = "";
    }
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (context) {
        return new Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton.icon(
                icon: Icon(CupertinoIcons.checkmark_alt),
                label: Text('Save'),
                onPressed: () {
                  if (currentClientId.isEmpty)
                    addClient();
                  else
                    updateClient(doc.id);

                  Navigator.pop(context);
                },
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
                      alignLabelWithHint: true,
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
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
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

  Future<void> addClient() {
    // Call the user's CollectionReference to add a new user
    CollectionReference clients =
        FirebaseFirestore.instance.collection('clients');
    var uuid = Uuid();
    return clients.add({
      'client_id': uuid.v1(),
      'client_name': _nameController.text, // John Doe
      'client_address': _addressController.text, // Stokes and Sons
      'client_mobile': _mobileController.text,
      'client_email': _emailController.text,
      'client_dob': _dobController.text,
      'client_remarks': _remarksController.text // 42
    }).then((value) {
      print("Client added!");
      _nameController.text = '';
      _addressController.text = '';
      _mobileController.text = '';
      _emailController.text = '';
      _dobController.text = '';
      _remarksController.text = '';
    }).catchError((error) => print("Failed to add client: $error"));
  }

  Future<void> updateClient(String _docId) {
    CollectionReference clients =
        FirebaseFirestore.instance.collection('clients');
    return clients.doc(_docId).update({
      'client_name': _nameController.text, // John Doe
      'client_address': _addressController.text, // Stokes and Sons
      'client_mobile': _mobileController.text,
      'client_email': _emailController.text,
      'client_dob': _dobController.text,
      'client_remarks': _remarksController.text
    }).then((value) {
      print('Client updated!');
      _nameController.text = '';
      _addressController.text = '';
      _mobileController.text = '';
      _emailController.text = '';
      _dobController.text = '';
      _remarksController.text = '';
    }).catchError((error) => print('Failed to update client: $error'));
  }

  Future<void> deleteClient(String _docId) {
    CollectionReference clients =
        FirebaseFirestore.instance.collection('clients');
    return clients
        .doc(_docId)
        .delete()
        .then((value) => print("Client deleted!"))
        .catchError((error) => print("Failed to delete client: $error"));
  }

  void _launchURL(String _url) async {
    if (_url.indexOf('+') < 0) _url = '+91' + _url;
    await canLaunch('tel:' + _url)
        ? await launch('tel:' + _url)
        : throw 'Could not launch $_url';
  }
}
