import 'package:biblioteca_app_json/model/book_model.dart';
import 'package:biblioteca_app_json/model/user_model.dart';

class EmprestimoModel {
  final String? id;
  final UsuarioModel usuario;
  final LivroModel livro;
  final DateTime startDate;
  final DateTime dueDate;
  final bool returned;

  EmprestimoModel({
    this.id,
    required this.usuario,
    required this.livro,
    required this.startDate,
    required this.dueDate,
    required this.returned
  });

  Map<String,dynamic> toMap() =>{
    "id":id,
    "usuariorId":usuario.toMap(),
    "livroId":livro.toMap(),
    "startDate":startDate.toIso8601String(),
    "dueDate":dueDate.toIso8601String(),
    "returned":returned
  };

  factory EmprestimoModel.fromMap(Map<String,dynamic> map)=> 
  EmprestimoModel(
    id: map["id"].toString(),
    usuario: UsuarioModel.fromMap(map["usuarioId"]),
    livro: LivroModel.fromMap(map["livroId"]),
    startDate: DateTime.parse(map["startDate"].toString()),
    dueDate: DateTime.parse(map["dueDate"].toString()),
    returned: map["returned"] == true ? true : false
  );
}