// Modelagem de Dados

class Nota {
  
  // Atributos
  final int? id; // Permite que a variável seja nula
  // Em primeiro momento a variável é nula
  // Somente quando cair no banco de dados irá receber um valor para o ID
  final String titulo;
  final String conteudo;

  // Constructor 
  Nota({this.id, required this.titulo, required this.conteudo});

  // Métodos de serialização de dados (toMap() e fromMap())
  // toMap() --> Converter um objeto da classe Nota pra Map do banco de dados, permitindo inserir os dados no banco
  Map<String, dynamic> toMap() {
    return {
      // Mapeando as colunas do database com os atributos da classe
      "id": id, 
      "titulo": titulo,
      "conteudo": conteudo
    };
  }

  // Converter um Map (vindo do banco de daods), para um objeto da classe Nota
  // Para o from vamos usar um factory
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota (
      // Se está voltando do database, então já tme um ID
      id: map["id"] as int, 
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String
    );
  }

  // Método para imprimir dados
  @override
  String toString() {
    return "Nota{id:$id, título: $titulo, conteúdo: $conteudo}";
  }
}