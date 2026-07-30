// Exemplo de uso do Convert Json

// Importar a biblioteca
import 'dart:convert'; // Biblioteca nativa do Dart não precisa usar pub add

void main(List<String> args) {
  // Declarando uma string em formato de coleção
  String dbJson = ''' {
        "id": 1,
        "nome": "Jão",
        "login": "jão_user",
        "status": true,
        "senha":  "0311",
        "endereço": {"Rua": "Alameda", "Numero": 3},
        "emails": ["jao@email.com", "jao2@email.com"]
    } ''';

  // Converter o texto Json --> Map Dart
  Map<String, dynamic> usuario = json.decode(dbJson);

  print(usuario["nome"]); // Printando informação da chave nome
  print(usuario["login"]); // Printando informação da chave de login

  // Mudando um valor
  usuario["senha"] = "1103";

  // Converter o Map em texto Json usando Encode
  String dbJson2 = json.encode(usuario);

  // Printando o texto Json
  print(dbJson2);
}
