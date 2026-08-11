class LivroModel {
  final String? id;
  final String titulo;
  final String autor;
  final bool avaliacao;


  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
    required this.avaliacao
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'autor': autor,
    'avaliacao': avaliacao
  };

  factory LivroModel.fromMap(Map<String, dynamic> map) => LivroModel(
      id: map['id'],
      titulo: map['titulo'], 
      autor: map['autor'],
      avaliacao: map['avaliacao'] == true ? true : false
  );
}