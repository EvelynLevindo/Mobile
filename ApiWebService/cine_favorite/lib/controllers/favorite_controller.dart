import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/database_service.dart';

class FavoriteController extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final int userId;

  List<Movie> favorites = [];
  bool isLoading = false;
  String? errorMessage;

  FavoriteController({required this.userId});

  Future<void> loadFavorites() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      favorites = await _dbService.getFavoriteMovies(userId);
    } catch (e) {
      errorMessage = 'Erro ao carregar favoritos: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int tmdbId) {
    return favorites.any((movie) => movie.id == tmdbId);
  }

  Future<void> addFavorite(Movie movie) async {
    try {
      await _dbService.addFavoriteMovie(userId, movie);
      favorites.add(movie);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao adicionar favorito: $e');
    }
  }

  Future<void> removeFavorite(int tmdbId) async {
    try {
      await _dbService.removeFavoriteMovie(userId, tmdbId);
      favorites.removeWhere((movie) => movie.id == tmdbId);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao remover favorito: $e');
    }
  }

  Future<void> updateRating(int tmdbId, int rating) async {
    try {
      await _dbService.updateMovieRating(userId, tmdbId, rating);
      final index = favorites.indexWhere((movie) => movie.id == tmdbId);
      if (index != -1) {
        favorites[index].rating = rating;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Erro ao atualizar nota: $e');
    }
  }
}