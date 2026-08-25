class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  int rating;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    required this.releaseDate,
    this.rating = 0,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? map['name'] ?? 'Título Desconhecido',
      posterPath: map['poster_path'],
      overview: map['overview'] ?? 'Sinopse não disponível.',
      releaseDate: map['release_date'] ?? map['first_air_date'] ?? 'Data não informada',
    );
  }

  factory Movie.fromDb(Map<String, dynamic> row) {
    return Movie(
      id: row['tmdb_id'],
      title: row['title'],
      posterPath: row['poster_path'],
      overview: '',
      releaseDate: '',
      rating: row['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'overview': overview,
      'release_date': releaseDate,
      'rating': rating,
    };
  }
}