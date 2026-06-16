import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/routine.dart';
import '../models/exercise.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workout_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure, // Importante para o CASCADE funcionar
      onCreate: _createDB,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        goal TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        routineId INTEGER NOT NULL,
        name TEXT NOT NULL,
        sets INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        type TEXT NOT NULL,
        FOREIGN KEY (routineId) REFERENCES routines (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- Operações para Rotinas (CRUD) ---
  Future<int> insertRoutine(Routine routine) async {
    final db = await instance.database;
    return await db.insert('routines', routine.toMap());
  }

  Future<List<Routine>> fetchRoutines() async {
    final db = await instance.database;
    final result = await db.query('routines');
    return result.map((json) => Routine.fromMap(json)).toList();
  }

  Future<int> updateRoutine(Routine routine) async {
    final db = await instance.database;
    return await db.update('routines', routine.toMap(), where: 'id = ?', whereArgs: [routine.id]);
  }

  Future<int> deleteRoutine(int id) async {
    final db = await instance.database;
    return await db.delete('routines', where: 'id = ?', whereArgs: [id]);
  }

  // --- Operações para Exercícios (CRUD) ---
  Future<int> insertExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<List<Exercise>> fetchExercises(int routineId) async {
    final db = await instance.database;
    final result = await db.query('exercises', where: 'routineId = ?', whereArgs: [routineId]);
    return result.map((json) => Exercise.fromMap(json)).toList();
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.update('exercises', exercise.toMap(), where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }
}