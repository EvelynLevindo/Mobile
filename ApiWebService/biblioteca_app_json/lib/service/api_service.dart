import 'dart:convert'; // Biblioteca nativa do Json
import 'package:http/http.dart' as http; // Importar biblioteca HTTP

class ApiService {
    static const String baseUrl = "http://10.87.38.135:3011"; // Url da base API

    // Métodos de classe para acessar os Endpoint da API
    // GET - All
    static Future<List<dynamic>> getList(String path) async {
        final res = await http.get(
            Uri.parse("$baseUrl/$path"),
        ); // No Dart é necessário converter uma String em endereço URL (URI.parse)
        if (res.statusCode == 200) return json.decode(res.body); 
        // Se a resposta estiver OK --> converte JSon em Map<dynamic>
        // Se der errado --> a conexão gera um erro
        throw Exception("Falha de Conexão $path");
    }

    // GET - One
    static Future<Map<String, dynamic>> getOne(String path, String id) async {
        final res = await http.get(Uri.parse("$baseUrl/$path/$id"));
        if (res.statusCode == 200) return json.decode(res.body);
        throw Exception("Falha de Conexão com $path");
    }

    // POST
    static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async{
        final res = await http.post(
            Uri.parse("$baseUrl/$path"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(body),
        );
        if (res.statusCode == 200) return jsonDecode(res.body);
        throw Exception("Falha de Conexão com $path"); 
    }

    // PUT
    static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body, String id) async {
      final res = await http.put(Uri.parse("$baseUrl/$path/$id"), headers: {"Content-Type": "application/json"}, body: json.encode(body),);
      if (res.statusCode == 200) return jsonDecode(res.body);
      throw Exception("Falha de Conexão com $path");
    }

    // DELETE
    static delete(String path, String id) async {
        final res = await http.delete(Uri.parse("$baseUrl/$path/$id"));
        if (res.statusCode != 200) throw Exception("Falha ao Deletar de $path");
    }
}