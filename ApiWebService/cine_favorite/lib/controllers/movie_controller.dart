import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieController extends ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();
  
  List<Movie> results = [];
  bool isLoading = false;
  String? errorMessage;
  String searchType = 'movie'; // 'movie' ou 'tv'
  
  Timer? _debounce;

  void setSearchType(String type) {
    searchType = type;
    results.clear();
    notifyListeners();
  }

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.trim().isEmpty) {
        results = [];
        errorMessage = null;
        notifyListeners();
        return;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        if (searchType == 'movie') {
          results = await _tmdbService.searchMovie(query);
        } else {
          results = await _tmdbService.searchTv(query);
        }
        
        if (results.isEmpty) {
          errorMessage = 'Nenhum resultado encontrado.';
        }
      } catch (e) {
        errorMessage = e.toString();
        results = [];
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}