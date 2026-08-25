import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../controllers/favorite_controller.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final FavoriteController favoriteController;

  const MovieDetailPage({
    Key? key,
    required this.movie,
    required this.favoriteController,
  }) : super(key: key);

  void _toggleFavorite(BuildContext context, bool isFavorite) async {
    try {
      if (isFavorite) {
        await favoriteController.removeFavorite(movie.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removido dos favoritos.')),
        );
      } else {
        await favoriteController.addFavorite(movie);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionado aos favoritos!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _updateRating(BuildContext context, int rating) async {
    try {
      await favoriteController.updateRating(movie.id, rating);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota atualizada!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (movie.posterPath != null)
              Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 300,
                  child: Center(child: Icon(Icons.error, size: 50)),
                ),
              )
            else
              const SizedBox(
                height: 300,
                child: Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Lançamento: ${movie.releaseDate}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('ID TMDB: ${movie.id}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Text(movie.overview, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: favoriteController,
                    builder: (context, _) {
                      final isFav = favoriteController.isFavorite(movie.id);
                      final favMovie = isFav ? favoriteController.favorites.firstWhere((m) => m.id == movie.id) : null;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _toggleFavorite(context, isFav),
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                            label: Text(isFav ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFav ? Colors.red.shade100 : Colors.blue.shade100,
                            ),
                          ),
                          if (isFav) ...[
                            const SizedBox(height: 20),
                            const Text('Sua Avaliação (0 a 5):', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<int>(
                              value: favMovie?.rating ?? 0,
                              items: List.generate(6, (index) => DropdownMenuItem(
                                value: index,
                                child: Text('$index Estrelas'),
                              )),
                              onChanged: (val) {
                                if (val != null) _updateRating(context, val);
                              },
                            )
                          ]
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}