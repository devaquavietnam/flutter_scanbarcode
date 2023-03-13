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
  List<scaninfo> _lst = [];
  TextEditingController serialnumController = TextEditingController();
  TextEditingController matcodeController = TextEditingController();
  TextEditingController dnnoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getScanInfoList();
  }

  Future<void> _incrementCounter() async {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   //_counter = _lst.length;
    // });
    // scaninfo si = new scaninfo(
    //     id: 3, serialnum: "AAAAAA", matcode: "matcode", dnno: "dnno");
    //dao.database();
    //dao.insertData(si);//
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

  Future<void> _getScanInfoList() async {
    List<scaninfo> lst = await dao.getAllData();
    setState(() {
      _lst = lst;
      _counter = lst.length;
    });
  }

  Future<void> _addScanToDatabase(scaninfo scanInfo) async {
    // Thêm dữ liệu vào database ở đây
    // ...
    // Sau khi thêm dữ liệu thành công, load danh sách mới từ database
    dao.insertData(scanInfo);
    await _getScanInfoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: dnnoController,
              decoration: InputDecoration(
                hintText: "Nhập số phiếu",
                labelText: "Số phiếu",
              ),
            ),
            TextField(
              controller: matcodeController,
              decoration: InputDecoration(
                hintText: "Nhập mã sản phẩm",
                labelText: "Mã sản phẩm",
              ),
            ),
            TextField(
              controller: serialnumController,
              decoration: InputDecoration(
                hintText: "Nhập số máy",
                labelText: "Số máy",
              ),
              onSubmitted: (value) {
                final newScanInfo = scaninfo(
                    serialnum: value,
                    matcode: matcodeController.text,
                    dnno: dnnoController.text,
                    createdate: DateTime.now().toIso8601String());
                _addScanToDatabase(newScanInfo);
              },
            ),
            Text(
              'Tổng số dòng : $_counter',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                // decoration: TextDecoration.underline,
                //decorationColor: Colors.red,
                decorationStyle: TextDecorationStyle.wavy,
              ),
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: FutureBuilder<List<scaninfo>>(
                future: Future.value(_lst),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final scanInfoList = snapshot.data!;

                  if (scanInfoList.isEmpty) {
                    return Center(
                      child: Text('No data available.'),
                    );
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        16.0, // set a fixed height for the ListView
                    child: ListView.builder(
                      itemCount: scanInfoList.length,
                      itemBuilder: (context, index) {
                        final scanInfo = scanInfoList[index];

                        return ListTile(
                          title: Text("Số máy: " + scanInfo.serialnum),
                          subtitle: Text("Số phiếu: " +
                              scanInfo.dnno +
                              "| Mã sản phẩm: " +
                              scanInfo.matcode),
                          //trailing: Text(scanInfo.dnno),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.import_export),
      ),
    );
  }
}
