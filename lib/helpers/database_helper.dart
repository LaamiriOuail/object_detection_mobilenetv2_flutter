import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "image_data.db";
  static const _databaseVersion = 1;
  static const table = 'images';

  static const columnId = '_id';
  static const columnDate = 'date';
  static const columnTime = 'time';
  static const columnImage = 'image';
  static const columnLabel = 'label';
  static const columnConfidence = 'confidence';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // The database object
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnImage TEXT NOT NULL,
        $columnLabel TEXT NOT NULL,
        $columnConfidence REAL NOT NULL
      )
    ''');
  }

  // Insert an image record into the database
  Future<int> insertImage(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }
}
