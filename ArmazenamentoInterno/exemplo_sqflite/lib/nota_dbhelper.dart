// Ajudante de conexão com o database
import 'package:exemplo_sqflite/nota_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotaDbhelper {

  // Atributos 
  static const String db_nome = "notas.db";
  static const String table_nome = "notas";
  static const String create_table = """
    
    CREATE TABLE IF NOT EXISTS $table_nome (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL ,
    conteudo TEXT NOT NULL)""";

  // Método de conexão
  // Método do tipo future (Async) que vai retornar o banco de dados
  Future<Database> _getDB() async { // Async --> O aplicativo não para de rodar, pega as informações do banco de dados sem travar
    return openDatabase(
      // Colocar o endereço do banco de dados
      join(await getDatabasesPath(), db_nome),
      onCreate: (db, version) { // Se é a primeira vez que está sendo executado, ele irá criar o banco de dados
        return db.execute(create_table);
      },
      version: 1,
    );
  } // Retorna o banco de dados ao final

  // CRUD do Banco de Dados (Controller)

  // 1. CREATE
  void create(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.insert(table_nome, nota.toMap()); // Insere o dado no banco
    } catch (e) { // E caso der errado, o dado será tratado no catch
      print(e);
      return;
    }
  }

  // 2. READ
  Future<List<Nota>> getNotas() async {
    try { 
      final Database db = await _getDB(); // Estabele a conexão 
      final List<Map<String, dynamic>> maps = await db.query(table_nome); // Pega todos os dados do banco
      // Converte o Map em List<Nota>
      return List.generate(maps.length, (e) => Nota.fromMap(maps[e])); // Retorna a lista com os objetivos
    } catch (e) {
      print(e); // Mostra o erro
      return []; // Retorna uma lista vazia
    }
  }

  // 3. UPDATE
  void updateNota(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.update(table_nome, nota.toMap(), where: "id = ?", whereArgs: [nota.id]);
    } catch (e) {
      print(e);
      return;
    }
  }

  // 4. DELETE
  void deleteNota (int id) async {
    try {
      final Database db = await _getDB();
      await db.delete(table_nome, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return;
    }
  }
}
