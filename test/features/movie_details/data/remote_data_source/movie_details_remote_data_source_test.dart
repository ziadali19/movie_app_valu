import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';
import 'package:movie_app_valu/features/movie_details/data/remote_data_source/movie_details_remote_data_source.dart';

import 'movie_details_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DioHelper>()])
void main() {
  group('MovieDetailsRemoteDataSource Tests', () {
    late MockDioHelper mockDioHelper;
    late MovieDetailsRemoteDataSource remoteDataSource;
    late Map<String, dynamic> testMovieDetailsData;

    setUp(() {
      mockDioHelper = MockDioHelper();
      remoteDataSource = MovieDetailsRemoteDataSource(mockDioHelper);

      testMovieDetailsData = {
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
    });

    group('getMovieDetails', () {
      test('should return ApiResponse<MovieDetails> when successful', () async {
        // Arrange
        const movieId = 1151334;
        final expectedResponse = Response(
          data: testMovieDetailsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        expect(result, isA<ApiResponse<MovieDetailsModel>>());
        expect(result.singleResult, isA<MovieDetailsModel>());
        expect(result.singleResult!.id, 1151334);
        expect(result.singleResult!.title, 'Eenie Meanie');
        expect(result.status, 0);

        verify(mockDioHelper.get('/movie/$movieId')).called(1);
      });

      test('should call DioHelper with correct endpoint', () async {
        // Arrange
        const movieId = 12345;
        final expectedResponse = Response(
          data: testMovieDetailsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        verify(mockDioHelper.get('/movie/$movieId')).called(1);
      });

      test('should parse movie details correctly from response', () async {
        // Arrange
        const movieId = 1151334;
        final expectedResponse = Response(
          data: testMovieDetailsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        final movieDetails = result.singleResult!;
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
        expect(movieDetails.genres[1].name, 'Action');
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
        expect(
          movieDetails.productionCompanies[0].name,
          '20th Century Studios',
        );
        expect(movieDetails.productionCountries.length, 1);
        expect(
          movieDetails.productionCountries[0].name,
          'United States of America',
        );
        expect(movieDetails.spokenLanguages.length, 1);
        expect(movieDetails.spokenLanguages[0].englishName, 'English');
      });

      test('should create ApiResponse with correct status code', () async {
        // Arrange
        const movieId = 1151334;
        final expectedResponse = Response(
          data: testMovieDetailsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        expect(result.status, 0);
        expect(result.isSuccess, true);
      });

      test(
        'should throw FailException when DioHelper throws an exception',
        () async {
          // Arrange
          const movieId = 1151334;
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/movie/$movieId'),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          );

          when(mockDioHelper.get('/movie/$movieId')).thenThrow(dioException);

          // Act & Assert
          expect(
            () => remoteDataSource.getMovieDetails(movieId: movieId),
            throwsA(isA<FailException>()),
          );

          verify(mockDioHelper.get('/movie/$movieId')).called(1);
        },
      );

      test('should handle different movie IDs correctly', () async {
        // Arrange
        const movieId = 99999;
        final modifiedData = Map<String, dynamic>.from(testMovieDetailsData);
        modifiedData['id'] = movieId;
        modifiedData['title'] = 'Different Movie';

        final expectedResponse = Response(
          data: modifiedData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        expect(result.singleResult!.id, movieId);
        expect(result.singleResult!.title, 'Different Movie');

        verify(mockDioHelper.get('/movie/$movieId')).called(1);
      });

      test('should handle minimal movie details response', () async {
        // Arrange
        const movieId = 12345;
        final minimalMovieData = {
          'id': movieId,
          'title': 'Minimal Movie',
          'overview': 'Minimal overview',
          'release_date': '2024-01-01',
          'vote_average': 7.5,
          'vote_count': 100,
          'runtime': 120,
          'original_language': 'en',
          'original_title': 'Minimal Movie',
          'popularity': 50.0,
          'adult': false,
          'video': false,
          'status': 'Released',
        };

        final expectedResponse = Response(
          data: minimalMovieData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/$movieId'),
        );

        when(
          mockDioHelper.get('/movie/$movieId'),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await remoteDataSource.getMovieDetails(movieId: movieId);

        // Assert
        final movieDetails = result.singleResult!;
        expect(movieDetails.id, movieId);
        expect(movieDetails.title, 'Minimal Movie');
        expect(movieDetails.overview, 'Minimal overview');
        expect(movieDetails.posterPath, null);
        expect(movieDetails.backdropPath, null);
        expect(movieDetails.genres, isEmpty);
        expect(movieDetails.tagline, null);
        expect(movieDetails.budget, null);
        expect(movieDetails.revenue, null);
        expect(movieDetails.homepage, null);
        expect(movieDetails.imdbId, null);
        expect(movieDetails.originCountry, isEmpty);
        expect(movieDetails.productionCompanies, isEmpty);
        expect(movieDetails.productionCountries, isEmpty);
        expect(movieDetails.spokenLanguages, isEmpty);
      });
    });

    group('Error handling', () {
      test('should wrap DioException in FailException', () async {
        // Arrange
        const movieId = 1151334;
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/movie/$movieId'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/movie/$movieId'),
          ),
        );

        when(mockDioHelper.get('/movie/$movieId')).thenThrow(dioException);

        // Act & Assert
        await expectLater(
          remoteDataSource.getMovieDetails(movieId: movieId),
          throwsA(isA<FailException>()),
        );
      });

      test('should wrap any other exception in FailException', () async {
        // Arrange
        const movieId = 1151334;
        final exception = Exception('Unknown error');

        when(mockDioHelper.get('/movie/$movieId')).thenThrow(exception);

        // Act & Assert
        expect(
          () => remoteDataSource.getMovieDetails(movieId: movieId),
          throwsA(isA<FailException>()),
        );
      });
    });
  });
}
