import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'classrooms.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE classrooms(id INTEGER PRIMARY KEY, number TEXT, info TEXT)',
        );
      },
    );
  }

  Future<void> insertClassroom(String number, String info) async {
    final db = await database;
    await db.insert(
      'classrooms',
      {'number': number, 'info': info},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getClassroomInfo(String number) async {
    final db = await database;
    final result = await db.query(
      'classrooms',
      where: 'number = ?',
      whereArgs: [number],
    );
    if (result.isNotEmpty) {
      return result.first['info'] as String?;
    }
    return null;
  }
}
