// ignore_for_file: prefer_const_constructors, unused_local_variable, unnecessary_new, avoid_print, avoid_function_literals_in_foreach_calls, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_scanbarcode/DAO/dao.dart';
import 'package:flutter_scanbarcode/DAO/scaninfo.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController serialnumController = TextEditingController();
  TextEditingController matcodeController = TextEditingController();
  TextEditingController dnnoController = TextEditingController();
  Future<void> _incrementCounter() async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    scaninfo si = new scaninfo(
        id: 3, serialnum: "AAAAAA", matcode: "matcode", dnno: "dnno");
    //dao.database();
    //dao.insertData(si);
    List<scaninfo> lst = await dao.getAllData();
    List<scaninfo> lstobj;
    Directory? _localFile = await getExternalStorageDirectory();
    String? appDocPath = _localFile?.path.toString();
    print(appDocPath);
    //final file = File('$appDocPath/counter.txt');
    // Write the file
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Ghi dữ liệu vào file Excel
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = "ID";
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = "serialnumber";
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = "materialcode";
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        .value = "LL";
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
        .value = "kkkk";
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
        .value = "ooo";
    // write data
    for (int i = 0; i < lst.length; i++) {
      scaninfo sc = lst[i];
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = sc.id;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = sc.serialnum;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
          .value = sc.matcode;
    }
    // Lưu file Excel vào thư mục Documents trên thiết bị
    String excelFilePath = '$appDocPath/example.xlsx';
    if (_localFile != null) {
      File file = File(excelFilePath);
      List<int>? bytes = excel.encode();
      file.createSync(recursive: true);
      file.writeAsBytes(bytes!);
    }
  }

  Future<List<scaninfo>> _getScanInfoList() async {
    List<scaninfo> lst = await dao.getAllData();
    int count = lst.length;
    print(count);
    return lst;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: serialnumController,
                  decoration: InputDecoration(
                    hintText: "Enter serial number",
                    labelText: "Serial Number",
                  ),
                ),
                TextField(
                  controller: matcodeController,
                  decoration: InputDecoration(
                    hintText: "Enter material code",
                    labelText: "Material Code",
                  ),
                ),
                TextField(
                  controller: dnnoController,
                  decoration: InputDecoration(
                    hintText: "Enter DN number",
                    labelText: "DN Number",
                  ),
                ),
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline6,
                ),
                // Expanded(
                //   child: FutureBuilder<List<scaninfo>>(
                //     future: _getScanInfoList(),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<List<scaninfo>> snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       } else if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       } else if (!snapshot.hasData) {
                //         return Text('No data found.');
                //       } else {
                //         return ListView.builder(
                //           itemCount: snapshot.data!.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             scaninfo scan = snapshot.data![index];
                //             return ListTile(
                //               title: Text(scan.serialnum),
                //               subtitle: Text("${scan.matcode} - ${scan.dnno}"),
                //             );
                //           },
                //         );
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
