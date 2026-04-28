class Habito {
  String id;
  String titulo;
  String descricao;
  bool isConcluido;

  Habito({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.isConcluido = false,
  });
}