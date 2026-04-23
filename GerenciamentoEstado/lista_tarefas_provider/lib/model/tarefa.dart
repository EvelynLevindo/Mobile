// Modelagem de Dados

class Tarefa {
  
  // Atributos
  String titulo; // Armazena o título da tarefa
  bool concluida; // Status da tarefa
  DateTime dataCriacao; // Classe que armazena informações de data

  // Contructor padrão
  // Tarefa(String titulo) {
  //   this.titulo = titulo;
  //   this.concluida = false;
  //   this.criacao = DateTime.now();
  // }

  Tarefa({
    required this.titulo,
    this.concluida =false,
    DateTime? dataCriacao,}) : dataCriacao = dataCriacao ?? DateTime.now();
    // Se a data de criação for nulo, atribui uma data (DateTime.now() --> pega a data atual)

  // Classe de modelagem de dados, então, toda tarefa criada é um objeto da classe tarefa
  // Toda tarefa tem um título, um status e uma data de criação
  
}