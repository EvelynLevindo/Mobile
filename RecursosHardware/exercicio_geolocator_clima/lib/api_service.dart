import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String chaveApi = "90290436d34bb91b4d852afe49197129";

  // Alterado para receber uma String com o nome da cidade em vez do Position
  Future<Map<String, dynamic>?> getClimaCidade(String cidade) async {
    // Parâmetro 'q' busca pelo nome da cidade. 'lang=pt_br' traz a descrição em português.
    final url = "$baseUrl?q=$cidade&appid=$chaveApi&units=metric&lang=pt_br";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Falha na conexão com o serviço de clima");
    }
  }
}