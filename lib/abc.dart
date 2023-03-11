// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController serialnumController = TextEditingController();
  TextEditingController matcodeController = TextEditingController();
  TextEditingController dnnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text("Text Boxes"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: serialnumController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: "Enter serial number",
                  labelText: "Serial Number",
                ),
              ),
              TextField(
                controller: matcodeController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: "Enter material code",
                  labelText: "Material Code",
                ),
              ),
              TextField(
                controller: dnnoController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: "Enter DN number",
                  labelText: "DN Number",
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
            ListTile(title: Text('Item 3')),
          ],
        ),
      ),
    );
  }
}
