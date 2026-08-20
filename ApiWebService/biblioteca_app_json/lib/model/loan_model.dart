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
    "userId": usuario.id, // Enviar apenas o ID é o padrão de APIs REST
    "bookId": livro.id,
    "loanDate": startDate.toIso8601String(),
    "returnDate": dueDate.toIso8601String(),
    "returned": returned
  };

  factory EmprestimoModel.fromMap(Map<String,dynamic> map)=> 
  EmprestimoModel(
    id: map["id"].toString(),
    usuario: UsuarioModel.fromMap(map["user"] ?? {}), // Requer parâmetro _expand=user na API
    livro: LivroModel.fromMap(map["book"] ?? {}), // Requer parâmetro _expand=book na API
    startDate: DateTime.parse(map["loanDate"].toString()),
    dueDate: DateTime.parse(map["returnDate"].toString()),
    returned: map["returned"] == true
  );