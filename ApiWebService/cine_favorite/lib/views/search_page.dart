import 'package:flutter/material.dart';
import '../controllers/movie_controller.dart';
import '../controllers/favorite_controller.dart';
import 'movie_detail_page.dart';

class SearchPage extends StatelessWidget {
  final MovieController movieController;
  final FavoriteController favoriteController;

  const SearchPage({
    Key? key,
    required this.movieController,
    required this.favoriteController,
  }) : super(key: key);

  Widget _buildPoster(String? path) {
    if (path == null || path.isEmpty) {
      return const SizedBox(
        width: 50,
        height: 75,
        child: Icon(Icons.image_not_supported),
      );
    }
    return Image.network(
      'https://image.tmdb.org/t/p/w500$path',
      width: 50,
      height: 75,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 50,
        height: 75,
        child: Icon(Icons.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedBuilder(
            animation: movieController,
            builder: (context, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'movie',
                    groupValue: movieController.searchType,
                    onChanged: (val) => movieController.setSearchType(val!),
                  ),
                  const Text('Filmes'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'tv',
                    groupValue: movieController.searchType,
                    onChanged: (val) => movieController.setSearchType(val!),
                  ),
                  const Text('Séries'),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar no TMDB',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: movieController.search,
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: movieController,
            builder: (context, _) {
              if (movieController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (movieController.errorMessage != null) {
                return Center(child: Text(movieController.errorMessage!));
              }

              if (movieController.results.isEmpty) {
                return const Center(child: Text('Digite algo para buscar.'));
              }

              return ListView.builder(
                itemCount: movieController.results.length,
                itemBuilder: (context, index) {
                  final movie = movieController.results[index];
                  return ListTile(
                    leading: _buildPoster(movie.posterPath),
                    title: Text(movie.title),
                    subtitle: Text(movie.releaseDate),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movie: movie,
                            favoriteController: favoriteController,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}