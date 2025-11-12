import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

Future<Directory> getAppVisionScanDirectory() async {
  Directory dir;

  if (Platform.isAndroid) {
    // Request permission (required for Android 13 and below)
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission not granted');
    }

    // Save in visible Documents folder
    final docsPath = Directory("/storage/emulated/0/Documents/Vision Scan");
    if (!(await docsPath.exists())) {
      await docsPath.create(recursive: true);
    }
    dir = docsPath;
  } else if (Platform.isIOS) {
    // Save inside app's visible Files folder
    final appDocs = await getApplicationDocumentsDirectory();
    final visionDir = Directory(appDocs.path);
    if (!(await visionDir.exists())) {
      await visionDir.create(recursive: true);
    }
    dir = visionDir;
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  return dir;
}


String getFormattedTimestamp() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}";
}
