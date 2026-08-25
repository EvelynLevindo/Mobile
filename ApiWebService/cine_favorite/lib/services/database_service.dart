import 'package:postgres/postgres.dart';
import '../config.dart';
import '../models/user.dart';
import '../models/movie.dart';

class DatabaseService {
  Future<Connection> _connect() async {
    try {
      return await Connection.open(
        Endpoint(
          host: Config.dbHost,
          port: Config.dbPort,
          database: Config.dbName,
          username: Config.dbUser,
          password: Config.dbPassword,
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
    } catch (e) {
      throw Exception('Erro ao conectar ao banco de dados: $e');
    }
  }

  Future<User> loginOrCreateUser(String username) async {
    final conn = await _connect();
    try {
      final result = await conn.execute(
        r'SELECT id, username FROM users WHERE username = $1',
        parameters: [username],
      );
      
      if (result.isNotEmpty) {
        return User(id: result[0][0] as int, username: result[0][1] as String);
      } else {
        final insertResult = await conn.execute(
          r'INSERT INTO users (username) VALUES ($1) RETURNING id, username',
          parameters: [username],
        );
        return User(id: insertResult[0][0] as int, username: insertResult[0][1] as String);
      }
    } finally {
      await conn.close();
    }
  }

  Future<List<Movie>> getFavoriteMovies(int userId) async {
    final conn = await _connect();
    try {
      final result = await conn.execute(
        r'SELECT tmdb_id, title, poster_path, rating FROM favorites WHERE user_id = $1',
        parameters: [userId],
      );
      
      return result.map((row) {
        return Movie.fromDb(row.toColumnMap());
      }).toList();
    } finally {
      await conn.close();
    }
  }

  Future<void> addFavoriteMovie(int userId, Movie movie) async {
    final conn = await _connect();
    try {
      await conn.execute(
        r'INSERT INTO favorites (user_id, tmdb_id, title, poster_path, rating) VALUES ($1, $2, $3, $4, $5)',
        parameters: [userId, movie.id, movie.title, movie.posterPath, movie.rating],
      );
    } catch (e) {
      throw Exception('Não foi possível adicionar aos favoritos. Talvez já exista? ($e)');
    } finally {
      await conn.close();
    }
  }

  Future<void> removeFavoriteMovie(int userId, int tmdbId) async {
    final conn = await _connect();
    try {
      await conn.execute(
        r'DELETE FROM favorites WHERE user_id = $1 AND tmdb_id = $2',
        parameters: [userId, tmdbId],
      );
    } finally {
      await conn.close();
    }
  }

  Future<void> updateMovieRating(int userId, int tmdbId, int rating) async {
    final conn = await _connect();
    try {
      await conn.execute(
        r'UPDATE favorites SET rating = $1 WHERE user_id = $2 AND tmdb_id = $3',
        parameters: [rating, userId, tmdbId],
      );
    } finally {
      await conn.close();
    }
  }
}