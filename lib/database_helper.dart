import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'yogurt_inventory.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE yogurts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,
        quantity INTEGER,
        sold INTEGER
      )
    ''');
  }

  Future<int> insertYogurt(Map<String, dynamic> yogurt) async {
    final db = await database;
    return await db.insert('yogurts', yogurt);
  }

  Future<List<Map<String, dynamic>>> getYogurts() async {
    final db = await database;
    return await db.query('yogurts');
  }

  Future<int> updateYogurt(Map<String, dynamic> yogurt) async {
    final db = await database;
    return await db.update(
      'yogurts',
      yogurt,
      where: 'id = ?',
      whereArgs: [yogurt['id']],
    );
  }

  Future<int> deleteYogurt(int id) async {
    final db = await database;
    return await db.delete(
      'yogurts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
