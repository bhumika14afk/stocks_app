import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:stocks_app/services/model_class.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static late Database _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final pathToDatabase = path.join(databasesPath, 'watchlist.db');

    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Watchlist ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'symbol TEXT NOT NULL, '
          'latestPrice TEXT NOT NULL'
          ')',
        );
      },
    );
  }

  Future<int> addToWatchlist(StockData stockData) async {
    final db = await database;
    return await db.insert('Watchlist', stockData.toJson());
  }

  Future<List<StockData>> getWatchlist() async {
    final db = await database;
    final records = await db.query('Watchlist');
    return records.map((record) => StockData.fromJson(record)).toList();
  }
}
