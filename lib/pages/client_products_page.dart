import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insugent/constants.dart';

class ClientProductsPage extends StatefulWidget {
  final String clientName;
  ClientProductsPage({this.clientName});
  @override
  _ClientProductsPageState createState() => _ClientProductsPageState();
}

class _ClientProductsPageState extends State<ClientProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              elevation: 1,
              leading: IconButton(
                icon: Icon(CupertinoIcons.back),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.grey[100],
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.clientName,
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'somebody@something.com',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ],
                  )),
            ),
          ];
        },
        body: Center(
          child: Text("Sample Text"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
