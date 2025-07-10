import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:visionscan/databases/qr_history.dart';
import 'package:visionscan/databases/qr_history_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [QrHistory])
abstract class AppDatabase extends FloorDatabase {
  QrHistoryDao get qrHistoryDao;
}
