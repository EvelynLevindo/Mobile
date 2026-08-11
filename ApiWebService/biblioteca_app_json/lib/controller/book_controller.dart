import 'package:biblioteca_app_json/model/book_model.dart';
import 'package:biblioteca_app_json/service/api_service.dart';

class LivroController {
  // Não precisa instanciar objetos de service --> Static

  // Métodos
  // Ler
  Future<List<LivroModel>> fetchAll() async {
    final list = await ApiService.getList("livro");
    return list.map<LivroModel>((item) => LivroModel.fromMap(item)).toList();
  }
  // Criar
  Future<LivroModel> create(LivroModel l) async {
    final created = await ApiService.post("livro", l.toMap());
    return LivroModel.fromMap(created);
  }

  // Atualizar
  Future<LivroModel> update(LivroModel l) async {
    final updated = await ApiService.put("livro", l.toMap(), l.id!);
    return LivroModel.fromMap(updated);
  }

  // Deletar
  Future<void> delete(String id) async {
    await ApiService.delete("livro", id);
  }
}