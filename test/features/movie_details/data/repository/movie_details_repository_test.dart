import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';
import 'package:movie_app_valu/features/movie_details/data/remote_data_source/movie_details_remote_data_source.dart';
import 'package:movie_app_valu/features/movie_details/data/repository/movie_details_repository.dart';
import 'package:movie_app_valu/features/movie_details/domain/entities/movie_details_entity.dart';

import 'movie_details_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BaseMovieDetailsRemoteDataSource>()])
void main() {
  group('MovieDetailsRepository Tests', () {
    late MockBaseMovieDetailsRemoteDataSource mockRemoteDataSource;
    late MovieDetailsRepository repository;
    late MovieDetailsModel testMovieDetails;
    late ApiResponse<MovieDetailsModel> testApiResponse;

    setUp(() {
      mockRemoteDataSource = MockBaseMovieDetailsRemoteDataSource();
      repository = MovieDetailsRepository(mockRemoteDataSource);

      testMovieDetails = MovieDetailsModel(
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
          GenreModel(id: 53, name: 'Thriller'),
          GenreModel(id: 28, name: 'Action'),
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
          ProductionCompanyModel(
            id: 127928,
            logoPath: '/h0rjX5vjW5r8yEnUBStFarjcLT4.png',
            name: '20th Century Studios',
            originCountry: 'US',
          ),
        ],
        productionCountries: [
          ProductionCountryModel(
            iso31661: 'US',
            name: 'United States of America',
          ),
        ],
        spokenLanguages: [
          SpokenLanguageModel(
            englishName: 'English',
            iso6391: 'en',
            name: 'English',
          ),
        ],
      );

      testApiResponse = ApiResponse<MovieDetailsModel>.fromTMDBSingle(
        results: testMovieDetails,
        statusCode: 200,
      );
    });

    group('getMovieDetails', () {
      test(
        'should return Right(ApiResponse<MovieDetails>) when remote data source succeeds',
        () async {
          // Arrange
          const movieId = 1151334;
          when(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).thenAnswer((_) async => testApiResponse);

          // Act
          final result = await repository.getMovieDetails(movieId: movieId);

          // Assert
          expect(
            result,
            isA<Right<ApiErrorModel, ApiResponse<MovieDetails>>>(),
          );

          result.fold((error) => fail('Expected Right but got Left: $error'), (
            apiResponse,
          ) {
            expect(apiResponse, testApiResponse);
            expect(apiResponse.singleResult, testMovieDetails);
            expect(apiResponse.status, 0);
            expect(apiResponse.isSuccess, true);
          });

          verify(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).called(1);
        },
      );

      test('should call remote data source with correct movie ID', () async {
        // Arrange
        const movieId = 12345;
        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenAnswer((_) async => testApiResponse);

        // Act
        await repository.getMovieDetails(movieId: movieId);

        // Assert
        verify(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return movie details correctly when successful', () async {
        // Arrange
        const movieId = 1151334;
        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenAnswer((_) async => testApiResponse);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        result.fold((error) => fail('Expected Right but got Left: $error'), (
          apiResponse,
        ) {
          final movieDetails = apiResponse.singleResult!;
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
          expect(movieDetails.originalLanguage, 'en');
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
      });

      test(
        'should return different movie details for different movie IDs',
        () async {
          // Arrange
          const movieId = 99999;
          final differentMovieDetails = MovieDetailsModel(
            id: 99999,
            title: 'Different Movie',
            overview: 'Different overview',
            releaseDate: '2024-01-01',
            voteAverage: 8.0,
            voteCount: 500,
            runtime: 90,
            genres: [],
            originalLanguage: 'en',
            originalTitle: 'Different Movie',
            popularity: 100.0,
            adult: false,
            video: false,
            status: 'Released',
            originCountry: [],
            productionCompanies: [],
            productionCountries: [],
            spokenLanguages: [],
            posterPath: '',
            backdropPath: '',
            tagline: '',
            budget: null,
            revenue: null,
            homepage: '',
            imdbId: '',
          );

          final differentApiResponse =
              ApiResponse<MovieDetailsModel>.fromTMDBSingle(
                results: differentMovieDetails,
                statusCode: 200,
              );

          when(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).thenAnswer((_) async => differentApiResponse);

          // Act
          final result = await repository.getMovieDetails(movieId: movieId);

          // Assert
          result.fold((error) => fail('Expected Right but got Left: $error'), (
            apiResponse,
          ) {
            expect(apiResponse.singleResult!.id, 99999);
            expect(apiResponse.singleResult!.title, 'Different Movie');
          });

          verify(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).called(1);
        },
      );
    });

    group('Error handling', () {
      test(
        'should return Left(ApiErrorModel) when remote data source throws FailException',
        () async {
          // Arrange
          const movieId = 1151334;
          final exception = Exception('Network error');
          final failException = FailException(exception: exception);

          when(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).thenThrow(failException);

          // Act
          final result = await repository.getMovieDetails(movieId: movieId);

          // Assert
          expect(result, isA<Left<ApiErrorModel, ApiResponse<MovieDetails>>>());

          result.fold(
            (error) {
              expect(error, isA<ApiErrorModel>());
              expect(error.message, isNotNull);
            },
            (apiResponse) => fail('Expected Left but got Right: $apiResponse'),
          );

          verify(
            mockRemoteDataSource.getMovieDetails(movieId: movieId),
          ).called(1);
        },
      );

      test('should handle different types of exceptions correctly', () async {
        // Arrange
        const movieId = 1151334;
        final networkException = Exception('Connection timeout');
        final failException = FailException(exception: networkException);

        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenThrow(failException);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        expect(result, isA<Left<ApiErrorModel, ApiResponse<MovieDetails>>>());

        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.message, isNotNull);
        }, (apiResponse) => fail('Expected Left but got Right: $apiResponse'));
      });

      test('should handle server error correctly', () async {
        // Arrange
        const movieId = 1151334;
        final serverException = Exception('Internal server error');
        final failException = FailException(exception: serverException);

        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenThrow(failException);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        expect(result, isA<Left<ApiErrorModel, ApiResponse<MovieDetails>>>());

        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.message, isNotNull);
        }, (apiResponse) => fail('Expected Left but got Right: $apiResponse'));

        verify(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).called(1);
      });

      test('should handle not found error correctly', () async {
        // Arrange
        const movieId = 999999; // Non-existent movie ID
        final notFoundException = Exception('Movie not found');
        final failException = FailException(exception: notFoundException);

        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenThrow(failException);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        expect(result, isA<Left<ApiErrorModel, ApiResponse<MovieDetails>>>());

        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.message, isNotNull);
        }, (apiResponse) => fail('Expected Left but got Right: $apiResponse'));

        verify(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).called(1);
      });
    });

    group('Integration scenarios', () {
      test('should handle successful flow end-to-end', () async {
        // Arrange
        const movieId = 1151334;
        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenAnswer((_) async => testApiResponse);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        expect(result.isRight(), true);

        result.fold((error) => fail('Expected success but got error: $error'), (
          apiResponse,
        ) {
          expect(apiResponse.isSuccess, true);
          expect(apiResponse.singleResult, isNotNull);
          expect(apiResponse.singleResult!.id, movieId);
          expect(apiResponse.status, 0);
        });

        verify(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should handle error flow end-to-end', () async {
        // Arrange
        const movieId = 1151334;
        final failException = FailException(exception: Exception('API Error'));

        when(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).thenThrow(failException);

        // Act
        final result = await repository.getMovieDetails(movieId: movieId);

        // Assert
        expect(result.isLeft(), true);

        result.fold(
          (error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.message, isNotNull);
          },
          (apiResponse) => fail('Expected error but got success: $apiResponse'),
        );

        verify(
          mockRemoteDataSource.getMovieDetails(movieId: movieId),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
  });
}
