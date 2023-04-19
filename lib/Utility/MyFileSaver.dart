import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class MyFileSaver {
  static Future<File?> saveFile(String fileName) async {
    final PermissionStatus permissionStatus =
        await Permission.storage.request();

    if (permissionStatus != PermissionStatus.granted) {
      return null;
    }

    // final String fileName = 'example.txt';
    final Directory? directory =
        await path_provider.getExternalStorageDirectory();

    if (directory == null) {
      return null;
    }

    final String filePath = path.join(directory.path, fileName);

    // Request user to create a new document file.
    final List<String> allowedTypes = <String>[
      'text/plain',
      'application/pdf',
      'image/jpeg',
      'image/png',
      'xls/xlsx'
    ];
    // ignore: prefer_const_declarations
    final String mimeType = 'text/plain';

    final bool isCreatingFile =
        await _createDocumentFile(filePath, mimeType, allowedTypes);

    if (!isCreatingFile) {
      return null;
    }

    final File file = File(filePath);

    if (!await file.exists()) {
      return null;
    }

    try {
      // Write to file.
      await file.writeAsString('Hello World!');

      return file;
    } on FileSystemException catch (e) {
      debugPrint('Failed to write to file: $e');
      return null;
    }
  }

  static Future<bool> _createDocumentFile(
      String filePath, String mimeType, List<String> allowedTypes) async {
    try {
      final Map<String, dynamic> params = <String, dynamic>{
        'title': path.basename(filePath),
        'mimeTypes': allowedTypes,
        'initialMimeType': mimeType,
      };

      // ignore: prefer_const_constructors
      final Uri? uri = await MethodChannel('plugins.flutter.io/document_picker')
          .invokeMethod<Uri>('pickDocument', params);

      if (uri != null) {
        final File file = File.fromUri(uri);

        if (!await file.exists()) {
          file.create();
        }

        return true;
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to create document file: $e');
    }

    return false;
  }
}
