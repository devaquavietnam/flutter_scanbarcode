// ignore_for_file: depend_on_referenced_packages, camel_case_types

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_scanbarcode/DAO/scaninfo.dart';

class dao {
  // Khởi tạo database và bảng
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'serialnumber.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tblserialnumber(id INTEGER PRIMARY KEY, serialnum TEXT, matcode TEXT, dnno TEXT,createdate TEXT,inout TEXT)",
        );
      },
      version: 103,
    );
  }

  static Future<void> deleteTable() async {
    final db = await database();
    await db.execute("DROP TABLE IF EXISTS tblserialnumber");
  }

  // Lấy toàn bộ dữ liệu
  static Future<List<scaninfo>> getAllData() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps =
        await db.query('tblserialnumber', orderBy: 'id DESC');
    return List.generate(maps.length, (i) {
      return scaninfo(
          id: maps[i]['id'],
          serialnum: maps[i]['serialnum'],
          matcode: maps[i]['matcode'],
          dnno: maps[i]['dnno'],
          createdate: maps[i]['createdate'],
          inout: maps[i]['inout']);
    });
  }

  Future<List<Map<String, dynamic>>> getAllScanInfoMapList() async {
    final Database db = await database();

    // query the table for all rows
    final List<Map<String, dynamic>> maps =
        await db.query('tblserialnumber', orderBy: 'createdate DESC');

    return maps;
  }

  // Thêm dữ liệu
  static Future<void> insertData(scaninfo scaninfo) async {
    final Database db = await database();
    await db.insert(
      'tblserialnumber',
      scaninfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // deleteTable();
  }

  Future<void> insertScanInfo(scaninfo scanInfo) async {
    final db = await database();
    await db.insert(
      'tblserialnumber',
      scanInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Sửa dữ liệu
  static Future<void> updateData(scaninfo objscaninfo) async {
    final Database db = await database();
    await db.update(
      'tblserialnumber',
      objscaninfo.toMap(),
      where: "id = ?",
      whereArgs: [objscaninfo.id],
    );
  }

  // Xóa dữ liệu
  static Future<void> deleteData(int id) async {
    final Database db = await database();
    await db.delete(
      'tblserialnumber',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
