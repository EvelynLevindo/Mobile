import 'package:flutter/material.dart';
import '../controllers/favorite_controller.dart';
import 'movie_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  final FavoriteController favoriteController;

  const FavoritesPage({Key? key, required this.favoriteController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: favoriteController,
      builder: (context, _) {
        if (favoriteController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (favoriteController.errorMessage != null) {
          return Center(child: Text(favoriteController.errorMessage!));
        }

        if (favoriteController.favorites.isEmpty) {
          return const Center(child: Text('Você ainda não possui favoritos.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final movie = favoriteController.favorites[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: movie.posterPath != null
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.error),
                            )
                          : const Icon(Icons.image_not_supported, size: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Nota: ${movie.rating}/5'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await favoriteController.removeFavorite(movie.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Favorito removido.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}