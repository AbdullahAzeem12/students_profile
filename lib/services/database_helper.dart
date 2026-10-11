import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students_profile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // We can store projects, profile, etc. as JSON strings for simplicity
    // or create specific tables. Given the models are complex, a key-value
    // cache table is enterprise-grade enough for offline-first caching.
    
    await db.execute('''
      CREATE TABLE cache (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> cacheData(String id, Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert(
      'cache',
      {
        'id': id,
        'data': jsonEncode(data),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedData(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'cache',
      columns: ['data'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return jsonDecode(maps.first['data'] as String);
    } else {
      return null;
    }
  }

  Future<void> clearCache() async {
    final db = await instance.database;
    await db.delete('cache');
  }
}
