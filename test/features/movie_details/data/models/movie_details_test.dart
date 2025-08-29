import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';

void main() {
  group('MovieDetails Model Tests', () {
    late MovieDetails testMovieDetails;
    late Map<String, dynamic> testMovieDetailsJson;

    setUp(() {
      testMovieDetailsJson = {
        'adult': false,
        'backdrop_path': '/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg',
        'belongs_to_collection': null,
        'budget': 50000000,
        'genres': [
          {'id': 53, 'name': 'Thriller'},
          {'id': 28, 'name': 'Action'},
        ],
        'homepage': 'https://www.20thcenturystudios.com/movies/eenie-meanie',
        'id': 1151334,
        'imdb_id': 'tt15514498',
        'origin_country': ['US'],
        'original_language': 'en',
        'original_title': 'Eenie Meanie',
        'overview':
            'A former teenage getaway driver gets dragged back into her unsavory past when a former employer offers her a chance to save the life of her chronically unreliable ex-boyfriend.',
        'popularity': 807.1247,
        'poster_path': '/12Va3oO3oYUdOd75zM57Nx1976a.jpg',
        'production_companies': [
          {
            'id': 127928,
            'logo_path': '/h0rjX5vjW5r8yEnUBStFarjcLT4.png',
            'name': '20th Century Studios',
            'origin_country': 'US',
          },
        ],
        'production_countries': [
          {'iso_3166_1': 'US', 'name': 'United States of America'},
        ],
        'release_date': '2025-08-21',
        'revenue': 0,
        'runtime': 106,
        'spoken_languages': [
          {'english_name': 'English', 'iso_639_1': 'en', 'name': 'English'},
        ],
        'status': 'Released',
        'tagline': 'He\'s her biggest blind spot.',
        'title': 'Eenie Meanie',
        'video': false,
        'vote_average': 6.684,
        'vote_count': 79,
      };

      testMovieDetails = MovieDetails(
        id: 1151334,
        title: 'Eenie Meanie',
        overview:
            'A former teenage getaway driver gets dragged back into her unsavory past when a former employer offers her a chance to save the life of her chronically unreliable ex-boyfriend.',
        posterPath: '/12Va3oO3oYUdOd75zM57Nx1976a.jpg',
        backdropPath: '/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg',
        releaseDate: '2025-08-21',
        voteAverage: 6.684,
        voteCount: 79,
        runtime: 106,
        genres: [
          const Genre(id: 53, name: 'Thriller'),
          const Genre(id: 28, name: 'Action'),
        ],
        originalLanguage: 'en',
        originalTitle: 'Eenie Meanie',
        popularity: 807.1247,
        adult: false,
        video: false,
        tagline: 'He\'s her biggest blind spot.',
        status: 'Released',
        budget: 50000000,
        revenue: 0,
        homepage: 'https://www.20thcenturystudios.com/movies/eenie-meanie',
        imdbId: 'tt15514498',
        originCountry: ['US'],
        productionCompanies: [
          const ProductionCompany(
            id: 127928,
            logoPath: '/h0rjX5vjW5r8yEnUBStFarjcLT4.png',
            name: '20th Century Studios',
            originCountry: 'US',
          ),
        ],
        productionCountries: [
          const ProductionCountry(
            iso31661: 'US',
            name: 'United States of America',
          ),
        ],
        spokenLanguages: [
          const SpokenLanguage(
            englishName: 'English',
            iso6391: 'en',
            name: 'English',
          ),
        ],
      );
    });

    group('fromJson', () {
      test('should create MovieDetails from JSON correctly', () {
        // Act
        final movieDetails = MovieDetails.fromJson(testMovieDetailsJson);

        // Assert
        expect(movieDetails.id, 1151334);
        expect(movieDetails.title, 'Eenie Meanie');
        expect(
          movieDetails.overview,
          contains('A former teenage getaway driver'),
        );
        expect(movieDetails.posterPath, '/12Va3oO3oYUdOd75zM57Nx1976a.jpg');
        expect(movieDetails.backdropPath, '/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg');
        expect(movieDetails.releaseDate, '2025-08-21');
        expect(movieDetails.voteAverage, 6.684);
        expect(movieDetails.voteCount, 79);
        expect(movieDetails.runtime, 106);
        expect(movieDetails.genres.length, 2);
        expect(movieDetails.genres[0].name, 'Thriller');
        expect(movieDetails.originalLanguage, 'en');
        expect(movieDetails.originalTitle, 'Eenie Meanie');
        expect(movieDetails.popularity, 807.1247);
        expect(movieDetails.adult, false);
        expect(movieDetails.video, false);
        expect(movieDetails.tagline, 'He\'s her biggest blind spot.');
        expect(movieDetails.status, 'Released');
        expect(movieDetails.budget, 50000000);
        expect(movieDetails.revenue, 0);
        expect(
          movieDetails.homepage,
          'https://www.20thcenturystudios.com/movies/eenie-meanie',
        );
        expect(movieDetails.imdbId, 'tt15514498');
        expect(movieDetails.originCountry, ['US']);
        expect(movieDetails.productionCompanies.length, 1);
        expect(movieDetails.productionCountries.length, 1);
        expect(movieDetails.spokenLanguages.length, 1);
      });

      test('should handle null/empty fields gracefully', () {
        // Arrange
        final minimalJson = {
          'id': 123,
          'title': 'Test Movie',
          'overview': 'Test overview',
          'release_date': '2024-01-01',
          'vote_average': 7.5,
          'vote_count': 100,
          'runtime': 120,
          'original_language': 'en',
          'original_title': 'Test Movie',
          'popularity': 50.0,
          'adult': false,
          'video': false,
          'status': 'Released',
        };

        // Act
        final movieDetails = MovieDetails.fromJson(minimalJson);

        // Assert
        expect(movieDetails.id, 123);
        expect(movieDetails.title, 'Test Movie');
        expect(movieDetails.posterPath, null);
        expect(movieDetails.backdropPath, null);
        expect(movieDetails.genres, []);
        expect(movieDetails.tagline, null);
        expect(movieDetails.budget, null);
        expect(movieDetails.revenue, null);
        expect(movieDetails.homepage, null);
        expect(movieDetails.imdbId, null);
        expect(movieDetails.originCountry, []);
        expect(movieDetails.productionCompanies, []);
        expect(movieDetails.productionCountries, []);
        expect(movieDetails.spokenLanguages, []);
      });
    });

    group('toJson', () {
      test('should convert MovieDetails to JSON correctly', () {
        // Act
        final json = testMovieDetails.toJson();

        // Assert
        expect(json['id'], 1151334);
        expect(json['title'], 'Eenie Meanie');
        expect(json['overview'], contains('A former teenage getaway driver'));
        expect(json['poster_path'], '/12Va3oO3oYUdOd75zM57Nx1976a.jpg');
        expect(json['backdrop_path'], '/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg');
        expect(json['release_date'], '2025-08-21');
        expect(json['vote_average'], 6.684);
        expect(json['vote_count'], 79);
        expect(json['runtime'], 106);
        expect(json['genres'], isA<List>());
        expect((json['genres'] as List).length, 2);
        expect(json['original_language'], 'en');
        expect(json['popularity'], 807.1247);
        expect(json['adult'], false);
        expect(json['video'], false);
        expect(json['tagline'], 'He\'s her biggest blind spot.');
        expect(json['status'], 'Released');
        expect(json['budget'], 50000000);
        expect(json['revenue'], 0);
        expect(
          json['homepage'],
          'https://www.20thcenturystudios.com/movies/eenie-meanie',
        );
        expect(json['imdb_id'], 'tt15514498');
        expect(json['origin_country'], ['US']);
        expect(json['production_companies'], isA<List>());
        expect(json['production_countries'], isA<List>());
        expect(json['spoken_languages'], isA<List>());
      });
    });

    group('Helper getters', () {
      test('should return correct full poster URL', () {
        // Act
        final fullPosterUrl = testMovieDetails.fullPosterUrl;

        // Assert
        expect(
          fullPosterUrl,
          'https://image.tmdb.org/t/p/w500/12Va3oO3oYUdOd75zM57Nx1976a.jpg',
        );
      });

      test('should return correct full backdrop URL', () {
        // Act
        final fullBackdropUrl = testMovieDetails.fullBackdropUrl;

        // Assert
        expect(
          fullBackdropUrl,
          'https://image.tmdb.org/t/p/w1280/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg',
        );
      });

      test('should return formatted runtime correctly', () {
        // Act
        final formattedRuntime = testMovieDetails.formattedRuntime;

        // Assert
        expect(formattedRuntime, '1h 46m');
      });

      test('should handle runtime edge cases', () {
        // Test with 0 runtime
        final movieWithZeroRuntime = testMovieDetails.copyWith(runtime: 0);
        expect(movieWithZeroRuntime.formattedRuntime, 'N/A');

        // Test with less than an hour
        final movieWith50Minutes = testMovieDetails.copyWith(runtime: 50);
        expect(movieWith50Minutes.formattedRuntime, '50m');

        // Test with exactly an hour
        final movieWith60Minutes = testMovieDetails.copyWith(runtime: 60);
        expect(movieWith60Minutes.formattedRuntime, '1h 0m');
      });

      test('should return genres text correctly', () {
        // Act
        final genresText = testMovieDetails.genresText;

        // Assert
        expect(genresText, 'Thriller, Action');
      });

      test('should return production companies text correctly', () {
        // Act
        final companiesText = testMovieDetails.productionCompaniesText;

        // Assert
        expect(companiesText, '20th Century Studios');
      });

      test('should return production countries text correctly', () {
        // Act
        final countriesText = testMovieDetails.productionCountriesText;

        // Assert
        expect(countriesText, 'United States of America');
      });

      test('should return spoken languages text correctly', () {
        // Act
        final languagesText = testMovieDetails.spokenLanguagesText;

        // Assert
        expect(languagesText, 'English');
      });

      test('should return origin country text correctly', () {
        // Act
        final originCountryText = testMovieDetails.originCountryText;

        // Assert
        expect(originCountryText, 'US');
      });

      test('should return release year correctly', () {
        // Act
        final releaseYear = testMovieDetails.releaseYear;

        // Assert
        expect(releaseYear, '2025');
      });

      test('should handle invalid release date gracefully', () {
        // Test with empty date
        final movieWithEmptyDate = testMovieDetails.copyWith(releaseDate: '');
        expect(movieWithEmptyDate.releaseYear, 'N/A');

        // Test with invalid date format
        final movieWithInvalidDate = testMovieDetails.copyWith(
          releaseDate: 'invalid-date',
        );
        expect(movieWithInvalidDate.releaseYear, 'N/A');
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        final anotherMovieDetails = MovieDetails.fromJson(testMovieDetailsJson);

        // Assert
        expect(testMovieDetails, equals(anotherMovieDetails));
        expect(testMovieDetails.hashCode, equals(anotherMovieDetails.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final differentMovieDetails = testMovieDetails.copyWith(
          title: 'Different Title',
        );

        // Assert
        expect(testMovieDetails, isNot(equals(differentMovieDetails)));
        expect(
          testMovieDetails.hashCode,
          isNot(equals(differentMovieDetails.hashCode)),
        );
      });
    });
  });

  group('Genre Model Tests', () {
    test('should create Genre from JSON correctly', () {
      // Arrange
      final genreJson = {'id': 28, 'name': 'Action'};

      // Act
      final genre = Genre.fromJson(genreJson);

      // Assert
      expect(genre.id, 28);
      expect(genre.name, 'Action');
    });

    test('should convert Genre to JSON correctly', () {
      // Arrange
      const genre = Genre(id: 28, name: 'Action');

      // Act
      final json = genre.toJson();

      // Assert
      expect(json['id'], 28);
      expect(json['name'], 'Action');
    });

    test('should handle equality correctly', () {
      // Arrange
      const genre1 = Genre(id: 28, name: 'Action');
      const genre2 = Genre(id: 28, name: 'Action');
      const genre3 = Genre(id: 35, name: 'Comedy');

      // Assert
      expect(genre1, equals(genre2));
      expect(genre1.hashCode, equals(genre2.hashCode));
      expect(genre1, isNot(equals(genre3)));
    });
  });

  group('ProductionCompany Model Tests', () {
    test('should create ProductionCompany from JSON correctly', () {
      // Arrange
      final companyJson = {
        'id': 127928,
        'logo_path': '/h0rjX5vjW5r8yEnUBStFarjcLT4.png',
        'name': '20th Century Studios',
        'origin_country': 'US',
      };

      // Act
      final company = ProductionCompany.fromJson(companyJson);

      // Assert
      expect(company.id, 127928);
      expect(company.logoPath, '/h0rjX5vjW5r8yEnUBStFarjcLT4.png');
      expect(company.name, '20th Century Studios');
      expect(company.originCountry, 'US');
    });

    test('should handle null logo path', () {
      // Arrange
      final companyJson = {
        'id': 127928,
        'logo_path': null,
        'name': '20th Century Studios',
        'origin_country': 'US',
      };

      // Act
      final company = ProductionCompany.fromJson(companyJson);

      // Assert
      expect(company.logoPath, null);
    });
  });

  group('ProductionCountry Model Tests', () {
    test('should create ProductionCountry from JSON correctly', () {
      // Arrange
      final countryJson = {
        'iso_3166_1': 'US',
        'name': 'United States of America',
      };

      // Act
      final country = ProductionCountry.fromJson(countryJson);

      // Assert
      expect(country.iso31661, 'US');
      expect(country.name, 'United States of America');
    });
  });

  group('SpokenLanguage Model Tests', () {
    test('should create SpokenLanguage from JSON correctly', () {
      // Arrange
      final languageJson = {
        'english_name': 'English',
        'iso_639_1': 'en',
        'name': 'English',
      };

      // Act
      final language = SpokenLanguage.fromJson(languageJson);

      // Assert
      expect(language.englishName, 'English');
      expect(language.iso6391, 'en');
      expect(language.name, 'English');
    });
  });
}

extension MovieDetailsCopyWith on MovieDetails {
  MovieDetails copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    int? runtime,
    List<Genre>? genres,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? adult,
    bool? video,
    String? tagline,
    String? status,
    int? budget,
    int? revenue,
    String? homepage,
    String? imdbId,
    List<String>? originCountry,
    List<ProductionCompany>? productionCompanies,
    List<ProductionCountry>? productionCountries,
    List<SpokenLanguage>? spokenLanguages,
  }) {
    return MovieDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      runtime: runtime ?? this.runtime,
      genres: genres ?? this.genres,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      video: video ?? this.video,
      tagline: tagline ?? this.tagline,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      homepage: homepage ?? this.homepage,
      imdbId: imdbId ?? this.imdbId,
      originCountry: originCountry ?? this.originCountry,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
    );
  }
}
