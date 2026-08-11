class UsuarioModel {
  final String? id;
  final String nome;
  final String email;

  UsuarioModel ({
    this.id,
    required this.nome,
    required this.email
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email
  };

  factory UsuarioModel.fromMap(Map<String, dynamic> map) => UsuarioModel(
    id: map['id'].toString(),
    nome: map['nome'].toString(), 
    email: map['map'].toString()
  );
}