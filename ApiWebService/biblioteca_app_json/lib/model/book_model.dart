class LivroModel {
  final String? id;
  final String titulo;
  final String autor;
  final bool status;


  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
    required this.status
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'autor': autor,
    'status': status
  };

  factory LivroModel.fromMap(Map<String, dynamic> map) => LivroModel(
      id: map['id'],
      titulo: map['titulo'], 
      autor: map['autor'],
      status: map['status'] == true ? true : false
  );
}