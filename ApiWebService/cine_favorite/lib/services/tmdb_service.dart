import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/movie.dart';

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.parse('$_baseUrl/search/movie?api_key=${Config.tmdbApiKey}&query=${Uri.encodeComponent(query)}&language=pt-BR');
    return _fetchData(url);
  }

  Future<List<Movie>> searchTv(String query) async {
    final url = Uri.parse('$_baseUrl/search/tv?api_key=${Config.tmdbApiKey}&query=${Uri.encodeComponent(query)}&language=pt-BR');
    return _fetchData(url);
  }

  Future<List<Movie>> _fetchData(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'] ?? [];
        return results.map((e) => Movie.fromMap(e)).toList();
      } else {
        throw Exception('Erro HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao buscar dados no TMDB: $e');
    }
  }
}