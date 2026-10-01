import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/punch_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ponto_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE punches(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            timestamp INTEGER,
            latitude REAL,
            longitude REAL
          )
        ''');
      },
    );
  }

  Future<void> addPunch(PunchModel punch) async {
    final db = await database;
    await db.insert('punches', punch.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PunchModel>> getUserPunches(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'punches',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => PunchModel.fromMap(maps[i]));
  }

  Future<PunchModel?> getLastPunch(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'punches',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return PunchModel.fromMap(maps.first);
    }
    return null;
  }
}