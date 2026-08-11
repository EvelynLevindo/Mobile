import 'package:biblioteca_app_json/model/user_model.dart';
import 'package:biblioteca_app_json/service/api_service.dart';

class UsuarioController {
  // Não precisa instanciar objetos de service --> Static

  // Métodos
  // Ler
  Future<List<UsuarioModel>> fetchAll() async {
    final list = await ApiService.getList("usuario?_sort=nome"); //?_sort=nome --> Flag para organizar em ordem alfabética os nomes
    // Retorna a lista de usuários convertidos para UsuarioModel
    return list.map<UsuarioModel>((item) => UsuarioModel.fromMap(item)).toList();
  }
  // Criar
  Future<UsuarioModel> create(UsuarioModel u) async {
    final created = await ApiService.post("usuario", u.toMap());
    // Adiciona um usuário e retorna o usuário criado --> ID
    return UsuarioModel.fromMap(created);
  }

  // Atualizar
  Future<UsuarioModel> update(UsuarioModel u) async {
    final updated = await ApiService.put("usuario", u.toMap(), u.id!);
    // Envia a atualização do usuário e retorna o usuário do Banco de Dados
    return UsuarioModel.fromMap(updated);
  }

  // Deletar
  Future<void> delete(String id) async {
    await ApiService.delete("usuario", id); // Se esse método não der certo, vai gerar uma exception
  }
}