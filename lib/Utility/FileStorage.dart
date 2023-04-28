import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
    static Future<String> createFolder() async {
        final dir = Directory((Platform.isAndroid
                ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationSupportDirectory() //FOR IOS
        )!.path);
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        if ((await dir.exists())) {
          return dir.path;
        } else {
          dir.create();
          return dir.path;
        }
      }

  // static Future<String> getExternalDocumentPath() async {
  //   // To check whether permission is given for this app or not.
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     // If not we will ask for permission first
  //     await Permission.storage.request();
  //   }
  //   String _directory;
  //   if (Platform.isAndroid) {
  //     // Redirects it to download folder in android    
  //     _directory = (await getExternalStorageDirectory())!.path;
  //   } else {
  //     _directory = (await getApplicationDocumentsDirectory()).path;
  //   }
  //   print("Saved Path: $_directory");
  //   await Directory(_directory).create(recursive: true);
  //   return _directory;
  // }

  static Future<String> get _localPath async {
    // To get the external path from device of download folder
    final String directory = await createFolder();
    return directory;
  }

  static Future<File> writeCounter(List<int>? bytes, String name) async {
    final path = await createFolder();
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');  
    file.createSync(recursive: true);
    // Write the data in the file you have created
    return file.writeAsBytes(bytes!);
  }
}
