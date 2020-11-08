import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insugent/helpers/adaptive.dart';
import 'package:insugent/helpers/my_flutter_app_icons.dart';
import 'package:insugent/models/insurance_brands_model.dart';
import 'package:insugent/providers/insurance_brand_api_provider.dart';

class BrandsPage extends StatefulWidget {
  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController<List<InsuranceBrand>> _brandController;
  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();

  bool isDesktop = false;
  String currentBrandId = "";

  loadBrands() async {
    Map<String, String> post = {
      'postdata': jsonEncode({'qry': '', 'sort': 'brand_name', 'pn': '0'})
    };
    InsuranceBrandApiProvider.fetchInsuranceBrands(post).then((res) async {
      _brandController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    _brandController = new StreamController();
    loadBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Brands'),
      ),
      body: StreamBuilder<List<InsuranceBrand>>(
        stream: _brandController.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<InsuranceBrand>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var brand = snapshot.data[index];
                return ListTile(
                  onTap: () {},
                  title: Text(brand.brandName),
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
        onPressed: () {
          _idController.text = "";
          _nameController.text = "";
          _showEdit(context);
        },
        child: Icon(LineIcons.add),
      ),
    );
  }

  void _showEdit(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: AppBar(
          title: Text('Edit School'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(LineIcons.check),
              label: Text('Save'),
              // onPressed: () => _saveSchool(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width:
                  isDesktop ? 500 : (MediaQuery.of(context).size.width * 0.8),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _idController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 10,
                      decoration:
                          InputDecoration(filled: true, labelText: 'ID'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      decoration:
                          InputDecoration(filled: true, labelText: 'Name'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}
