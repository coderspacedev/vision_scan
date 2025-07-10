// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  QrHistoryDao? _qrHistoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `qr_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `qrContent` TEXT NOT NULL, `type` TEXT NOT NULL, `style` TEXT NOT NULL, `color` TEXT NOT NULL, `brushType` TEXT NOT NULL, `isCornered` INTEGER NOT NULL, `timestamp` INTEGER NOT NULL, `historyType` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  QrHistoryDao get qrHistoryDao {
    return _qrHistoryDaoInstance ??= _$QrHistoryDao(database, changeListener);
  }
}

class _$QrHistoryDao extends QrHistoryDao {
  _$QrHistoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _qrHistoryInsertionAdapter = InsertionAdapter(
            database,
            'qr_history',
            (QrHistory item) => <String, Object?>{
                  'id': item.id,
                  'qrContent': item.qrContent,
                  'type': item.type,
                  'style': item.style,
                  'color': item.color,
                  'brushType': item.brushType,
                  'isCornered': item.isCornered ? 1 : 0,
                  'timestamp': item.timestamp,
                  'historyType': item.historyType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QrHistory> _qrHistoryInsertionAdapter;

  @override
  Future<List<QrHistory>> getHistoryByType(String type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM qr_history WHERE historyType = ?1 ORDER BY timestamp DESC',
        mapper: (Map<String, Object?> row) => QrHistory(id: row['id'] as int?, qrContent: row['qrContent'] as String, type: row['type'] as String, style: row['style'] as String, color: row['color'] as String, brushType: row['brushType'] as String, isCornered: (row['isCornered'] as int) != 0, timestamp: row['timestamp'] as int, historyType: row['historyType'] as String),
        arguments: [type]);
  }

  @override
  Future<void> clearHistoryByType(String type) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM qr_history WHERE historyType = ?1',
        arguments: [type]);
  }

  @override
  Future<void> insertHistory(QrHistory history) async {
    await _qrHistoryInsertionAdapter.insert(
        history, OnConflictStrategy.replace);
  }
}
