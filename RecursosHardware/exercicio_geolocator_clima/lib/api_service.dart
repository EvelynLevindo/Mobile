import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String chaveApi = "90290436d34bb91b4d852afe49197129";

  Future<Map<String, dynamic>?> getClimaLocation(Position position) async {
    // Adicionado &units=metric para retornar a temperatura em Celsius
    final url = "$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$chaveApi&units=metric";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Falha na conexão com o serviço de clima");
    }
  }
}