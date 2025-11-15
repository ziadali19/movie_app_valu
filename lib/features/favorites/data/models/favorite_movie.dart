import 'package:hive/hive.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';

part 'favorite_movie.g.dart';

@HiveType(typeId: 0)
class FavoriteMovie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? posterPath;

  @HiveField(3)
  final double voteAverage;

  @HiveField(4)
  final String releaseDate;

  @HiveField(5)
  final String overview;

  @HiveField(6)
  final DateTime addedAt;

  @HiveField(7)
  final int voteCount;

  @HiveField(8)
  final List<int> genreIds;

  FavoriteMovie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.addedAt,
    required this.voteCount,
    required this.genreIds,
  });

  // Factory constructor from Movie (for adding from movie lists)
  factory FavoriteMovie.fromMovie(Movie movie) {
    return FavoriteMovie(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      overview: movie.overview,
      addedAt: DateTime.now(),
      voteCount: movie.voteCount,
      genreIds: movie.genreIds,
    );
  }

  // Factory constructor from MovieDetails (for adding from details screen)
  factory FavoriteMovie.fromMovieDetails(MovieDetailsModel movieDetails) {
    return FavoriteMovie(
      id: movieDetails.id,
      title: movieDetails.title,
      posterPath: movieDetails.posterPath,
      voteAverage: movieDetails.voteAverage,
      releaseDate: movieDetails.releaseDate,
      overview: movieDetails.overview,
      addedAt: DateTime.now(),
      voteCount: movieDetails.voteCount,
      genreIds: movieDetails.genres.map((genre) => genre.id).toList(),
    );
  }

  // Convert to Movie for UI consumption
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: null, // Not stored in favorites
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
      adult: false, // Default value
      originalLanguage: 'en', // Default value
      originalTitle: title, // Use title as fallback
      popularity: 0.0, // Not relevant for favorites
      video: false, // Default value
    );
  }

  // Helper getters
  String get fullPosterUrl {
    if (posterPath == null || posterPath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get formattedYear {
    if (releaseDate.isEmpty) return '';
    try {
      return DateTime.parse(releaseDate).year.toString();
    } catch (e) {
      return '';
    }
  }

  String get formattedAddedDate {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteMovie &&
        other.id == id &&
        other.title == title &&
        other.posterPath == posterPath &&
        other.voteAverage == voteAverage &&
        other.releaseDate == releaseDate &&
        other.overview == overview &&
        other.addedAt == addedAt &&
        other.voteCount == voteCount &&
        other.genreIds.length == genreIds.length;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    posterPath,
    voteAverage,
    releaseDate,
    overview,
    addedAt,
    voteCount,
    genreIds.length,
  );

  @override
  String toString() {
    return 'FavoriteMovie{id: $id, title: $title, addedAt: $addedAt}';
  }
}
