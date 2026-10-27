import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String _host = 'itunes.apple.com';

  Future<List<Song>> searchSongs(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final uri = Uri.https(_host, '/search', {
        'term': cleanQuery,
        'media': 'music',
        'entity': 'song',
        'limit': '30',
      });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        return results
            .where((m) => m['previewUrl'] != null && (m['previewUrl'] as String).isNotEmpty)
            .map((m) => Song.fromMap(m))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar músicas: $e');
    }
    return [];
  }

  Future<List<Song>> searchArtists(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final uri = Uri.https(_host, '/search', {
        'term': cleanQuery,
        'media': 'music',
        'entity': 'song',
        'attribute': 'artistTerm',
        'limit': '25',
      });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        return results
            .where((m) => m['previewUrl'] != null && (m['previewUrl'] as String).isNotEmpty)
            .map((m) => Song.fromMap(m))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar por artista: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> searchAlbums(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final uri = Uri.https(_host, '/search', {
        'term': cleanQuery,
        'media': 'music',
        'entity': 'album',
        'limit': '20',
      });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        return results.map((m) => {
          'id': m['collectionId']?.toString() ?? '',
          'title': m['collectionName'] ?? 'Álbum',
          'artist': m['artistName'] ?? 'Artista',
          'coverUrl': (m['artworkUrl100'] as String? ?? '').replaceAll('100x100', '400x400'),
          'trackCount': m['trackCount'] ?? 0,
          'genre': m['primaryGenreName'] ?? 'Música',
        }).toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar álbuns: $e');
    }
    return [];
  }

  Future<List<Song>> getPopular() async => searchSongs('pop dance hits');

  Future<List<Song>> getRecommendations(String genre) async {
    final terms = {
      'Tudo': 'pop hits',
      'Pop Galáctico': 'electropop dance',
      'Eletrônica & Synth': 'synthwave cyberpunk',
      'Lo-fi Mágico': 'lofi chill beats',
      'Rock & Instrumentais': 'instrumental melodic rock',
      'Winx & Fairy': 'fairy dance pop anime',
    };
    final query = terms[genre] ?? genre;
    return searchSongs(query);
  }

  Future<List<Map<String, dynamic>>> getFeaturedAlbums() async {
    final albums = await searchAlbums('electronic pop');
    if (albums.isNotEmpty) return albums;
    return searchAlbums('pop');
  }
}