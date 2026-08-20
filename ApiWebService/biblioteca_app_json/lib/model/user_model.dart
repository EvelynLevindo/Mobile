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
    'name': nome, // Corrigido para 'name'
    'email': email
  };

  factory UsuarioModel.fromMap(Map<String, dynamic> map) => UsuarioModel(
    id: map['id'].toString(),
    nome: map['name'].toString(), // Corrigido para 'name'
    email: map['email'].toString() // Corrigido erro map['map']
  );
}