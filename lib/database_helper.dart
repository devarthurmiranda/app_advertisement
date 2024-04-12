import 'package:app_anuncios/model/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_anuncios/database/helpers/product_helper.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database?> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'productDatabase.db');

    try {
      return _db = await openDatabase(path,
          version: 2, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future _onCreateDB(Database db, int newVersion) async {
    await db.execute(ProductHelper.createScript);
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE ${ProductHelper.tableName};");
      await _onCreateDB(db, newVersion);
    }
  }

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }
}
