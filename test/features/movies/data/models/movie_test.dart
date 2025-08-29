import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    late Movie testMovie;
    late Map<String, dynamic> testMovieJson;

    setUp(() {
      testMovieJson = {
        'id': 123,
        'title': 'Test Movie',
        'overview': 'This is a test movie overview',
        'poster_path': '/test_poster.jpg',
        'backdrop_path': '/test_backdrop.jpg',
        'release_date': '2024-08-28',
        'vote_average': 8.5,
        'vote_count': 1000,
        'genre_ids': [28, 12],
        'adult': false,
        'original_language': 'en',
        'original_title': 'Test Original Movie',
        'popularity': 123.45,
        'video': false,
      };

      testMovie = Movie(
        id: 123,
        title: 'Test Movie',
        overview: 'This is a test movie overview',
        posterPath: '/test_poster.jpg',
        backdropPath: '/test_backdrop.jpg',
        releaseDate: '2024-08-28',
        voteAverage: 8.5,
        voteCount: 1000,
        genreIds: [28, 12],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Test Original Movie',
        popularity: 123.45,
        video: false,
      );
    });

    test('should create Movie from JSON correctly', () {
      // Act
      final movie = Movie.fromJson(testMovieJson);

      // Assert
      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.overview, 'This is a test movie overview');
      expect(movie.posterPath, '/test_poster.jpg');
      expect(movie.releaseDate, '2024-08-28');
      expect(movie.voteAverage, 8.5);
      expect(movie.voteCount, 1000);
      expect(movie.genreIds, [28, 12]);
      expect(movie.adult, false);
    });

    test('should convert Movie to JSON correctly', () {
      // Act
      final json = testMovie.toJson();

      // Assert
      expect(json['id'], 123);
      expect(json['title'], 'Test Movie');
      expect(json['overview'], 'This is a test movie overview');
      expect(json['poster_path'], '/test_poster.jpg');
      expect(json['release_date'], '2024-08-28');
      expect(json['vote_average'], 8.5);
      expect(json['vote_count'], 1000);
      expect(json['genre_ids'], [28, 12]);
      expect(json['adult'], false);
    });

    test('should return correct full poster URL', () {
      // Act
      final fullPosterUrl = testMovie.fullPosterUrl;

      // Assert
      expect(fullPosterUrl, 'https://image.tmdb.org/t/p/w500/test_poster.jpg');
    });

    test('should return empty string when poster path is null', () {
      // Arrange
      final movieWithoutPoster = Movie(
        id: 123,
        title: 'Test Movie',
        overview: 'This is a test movie overview',
        posterPath: null,
        releaseDate: '2024-08-28',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12],
        originalLanguage: 'en',
        originalTitle: 'Test Original Movie',
        popularity: 123.45,
        video: false,
      );

      // Act
      final fullPosterUrl = movieWithoutPoster.fullPosterUrl;

      // Assert
      expect(fullPosterUrl, '');
    });

    test('should return formatted rating correctly', () {
      // Act
      final formattedRating = testMovie.formattedRating;

      // Assert
      expect(formattedRating, '8.5');
    });

    test('should return formatted year correctly', () {
      // Act
      final formattedYear = testMovie.formattedYear;

      // Assert
      expect(formattedYear, '2024');
    });

    test('should return empty string when release date is empty', () {
      // Arrange
      final movieWithoutDate = testMovie.copyWith(releaseDate: '');

      // Act
      final formattedYear = movieWithoutDate.formattedYear;

      // Assert
      expect(formattedYear, '');
    });

    test('should handle invalid date format gracefully', () {
      // Arrange
      final movieWithInvalidDate = testMovie.copyWith(
        releaseDate: 'invalid-date',
      );

      // Act
      final formattedYear = movieWithInvalidDate.formattedYear;

      // Assert
      expect(formattedYear, '');
    });
  });
}
