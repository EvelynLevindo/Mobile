import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'registro_ponto.dart';

class RegistroDatabase {
  static Database? _database;
  static const String _tableName = 'registros';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'senai_checkin.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data_hora TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            observacao TEXT NOT NULL,
            foto_path TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<int> inserir(RegistroPonto registro) async {
    final db = await database;
    return db.insert(_tableName, registro.toMap());
  }

  static Future<List<RegistroPonto>> listar() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'data_hora DESC',
    );

    return maps.map(RegistroPonto.fromMap).toList();
  }
}