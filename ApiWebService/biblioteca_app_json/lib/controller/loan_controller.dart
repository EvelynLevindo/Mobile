import 'package:biblioteca_app_json/model/loan_model.dart';
import 'package:biblioteca_app_json/service/api_service.dart';

class EmprestimoController {
  // Não precisa instanciar objetos de service --> Static

  // Métodos
  // Ler
  Future<List<EmprestimoModel>> fetchAll() async {
    final list = await ApiService.getList('emprestimo?_sort=loanDate');
    return list.map<EmprestimoModel>((item) => EmprestimoModel.fromMap(item)).toList();
  }
  // Criar
  Future<EmprestimoModel> create(EmprestimoModel e) async {
    final created = await ApiService.post("emprestimo", e.toMap());
    return EmprestimoModel.fromMap(created);
  }

  // Atualizar
  Future<EmprestimoModel> update(EmprestimoModel e) async {
    final updated = await ApiService.put("emprestimo", e.toMap(), e.id!);
    return EmprestimoModel.fromMap(updated);
  }

  // Deletar
  Future<void> delete(String id) async {
    await ApiService.delete("emprestimo", id);
  }
}