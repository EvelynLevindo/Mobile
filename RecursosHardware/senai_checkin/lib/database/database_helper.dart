import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/registro.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('senai_checkin.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE registros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_hora TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        observacao TEXT,
        caminho_foto TEXT
      )
    ''');
  }

  Future<int> insertRegistro(Registro registro) async {
    final db = await instance.database;
    return await db.insert('registros', registro.toMap());
  }

  Future<List<Registro>> getAllRegistros() async {
    final db = await instance.database;
    final result = await db.query('registros', orderBy: 'id DESC');
    return result.map((json) => Registro.fromMap(json)).toList();
  }

  Future<Registro?> getRegistroById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'registros',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Registro.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRegistro(Registro registro) async {
    final db = await instance.database;
    return db.update(
      'registros',
      registro.toMap(),
      where: 'id = ?',
      whereArgs: [registro.id],
    );
  }

  Future<int> deleteRegistro(int id) async {
    final db = await instance.database;
    return await db.delete(
      'registros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}