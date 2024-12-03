import 'dart:typed_data';
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

  // Getter for database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initializes the database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Creates the table when the database is first created
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnImage BLOB NOT NULL,  -- Changed to BLOB for image bytes
        $columnLabel TEXT NOT NULL,
        $columnConfidence REAL NOT NULL
      )
    ''');
  }

  // Insert image data into the database
  Future<void> insertImageData({
    required String date,
    required String time,
    required Uint8List image, // Image as bytes
    required String label,
    required double confidence,
  }) async {
    final db = await database;

    await db.insert(
      table,
      {
        columnDate: date,
        columnTime: time,
        columnImage: image,
        columnLabel: label,
        columnConfidence: confidence,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces existing records if necessary
    );
  }

  // Method to fetch all image records
  Future<List<Map<String, dynamic>>> fetchAllImages() async {
    final db = await database;

    // Fetch all images sorted by date and time in descending order
    return await db.query(
      table,
      orderBy: '$columnDate DESC, $columnTime DESC', // Order by date and time, descending
    );
  }



  // Method to fetch a specific image record by id
  Future<Map<String, dynamic>?> fetchImageById(int id) async {
    final db = await database;
    final result = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Method to delete an image record by id
  Future<void> deleteImageById(int id) async {
    final db = await database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Method to update an image record by id
  Future<void> updateImageData({
    required int id,
    required String date,
    required String time,
    required Uint8List image,
    required String label,
    required double confidence,
  }) async {
    final db = await database;
    await db.update(
      table,
      {
        columnDate: date,
        columnTime: time,
        columnImage: image,
        columnLabel: label,
        columnConfidence: confidence,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
