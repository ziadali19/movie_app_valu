import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movies/data/remote_data_source/movies_remote_data_source.dart';
import 'package:movie_app_valu/features/movies/data/repository/movies_repository.dart';

import 'movies_repository_test.mocks.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<BaseMoviesRemoteDataSource>()])
void main() {
  group('MoviesRepository Tests', () {
    late MoviesRepository repository;
    late MockBaseMoviesRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockBaseMoviesRemoteDataSource();
      repository = MoviesRepository(mockRemoteDataSource);
    });

    final testMovies = [
      Movie(
        id: 1,
        title: 'Test Movie 1',
        overview: 'Test overview 1',
        posterPath: '/test1.jpg',
        releaseDate: '2024-01-01',
        voteAverage: 8.0,
        voteCount: 100,
        adult: false,
        genreIds: [28],
        originalLanguage: 'en',
        originalTitle: 'Test Movie 1',
        popularity: 100.0,
        video: false,
      ),
      Movie(
        id: 2,
        title: 'Test Movie 2',
        overview: 'Test overview 2',
        posterPath: '/test2.jpg',
        releaseDate: '2024-01-02',
        voteAverage: 7.5,
        voteCount: 200,
        adult: false,
        genreIds: [35],
        originalLanguage: 'en',
        originalTitle: 'Test Movie 2',
        popularity: 90.0,
        video: false,
      ),
    ];

    final testApiResponse = ApiResponse<List<Movie>>.fromTMDBPaginated(
      json: {
        'page': 1,
        'results': testMovies.map((movie) => movie.toJson()).toList(),
        'total_pages': 10,
        'total_results': 200,
      },
      results: testMovies,
      statusCode: 200,
    );

    group('getPopularMovies', () {
      test(
        'should return Right with ApiResponse when remote data source succeeds',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getPopularMovies(page: 1),
          ).thenAnswer((_) async => testApiResponse);

          // Act
          final result = await repository.getPopularMovies(page: 1);

          // Assert
          expect(result, isA<Right<ApiErrorModel, ApiResponse<List<Movie>>>>());

          result.fold(
            (error) => fail(
              'Expected Right but got Left with error: ${error.message}',
            ),
            (response) {
              expect(response.page, 1);
              expect(response.resultsList?.length, 2);
              expect(response.resultsList?.first.title, 'Test Movie 1');
              expect(response.totalPages, 10);
              expect(response.totalResults, 200);
            },
          );

          // Verify the remote data source was called with correct parameters
          verify(mockRemoteDataSource.getPopularMovies(page: 1)).called(1);
        },
      );

      test(
        'should return Right with default page when no page specified',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getPopularMovies(page: 1),
          ).thenAnswer((_) async => testApiResponse);

          // Act
          final result = await repository.getPopularMovies();

          // Assert
          expect(result, isA<Right<ApiErrorModel, ApiResponse<List<Movie>>>>());

          // Verify the remote data source was called with default page
          verify(mockRemoteDataSource.getPopularMovies(page: 1)).called(1);
        },
      );

      test(
        'should return Left with ApiErrorModel when FailException is thrown',
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/test'),
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 404,
              data: {
                'status_message':
                    'The resource you requested could not be found.',
              },
            ),
            type: DioExceptionType.badResponse,
          );

          when(
            mockRemoteDataSource.getPopularMovies(page: 1),
          ).thenThrow(FailException(exception: dioException));

          // Act
          final result = await repository.getPopularMovies(page: 1);

          // Assert
          expect(result, isA<Left<ApiErrorModel, ApiResponse<List<Movie>>>>());

          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.message, isNotNull);
          }, (response) => fail('Expected Left but got Right'));

          verify(mockRemoteDataSource.getPopularMovies(page: 1)).called(1);
        },
      );

      test('should return Left when network timeout occurs', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        when(
          mockRemoteDataSource.getPopularMovies(page: 1),
        ).thenThrow(FailException(exception: dioException));

        // Act
        final result = await repository.getPopularMovies(page: 1);

        // Assert
        expect(result, isA<Left<ApiErrorModel, ApiResponse<List<Movie>>>>());

        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.message, isNotNull);
        }, (response) => fail('Expected Left but got Right'));
      });

      test(
        'should call remote data source with correct page parameter',
        () async {
          // Arrange
          const testPage = 5;
          when(
            mockRemoteDataSource.getPopularMovies(page: testPage),
          ).thenAnswer((_) async => testApiResponse);

          // Act
          await repository.getPopularMovies(page: testPage);

          // Assert
          verify(
            mockRemoteDataSource.getPopularMovies(page: testPage),
          ).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}
