import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movies/data/remote_data_source/movies_remote_data_source.dart';

import 'movies_remote_data_source_test.mocks.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<DioHelper>()])
void main() {
  group('MoviesRemoteDataSource Tests', () {
    late MoviesRemoteDataSource dataSource;
    late MockDioHelper mockDioHelper;

    setUp(() {
      mockDioHelper = MockDioHelper();
      dataSource = MoviesRemoteDataSource(mockDioHelper);
    });

    final testMovieJson1 = {
      'id': 1,
      'title': 'Test Movie 1',
      'overview': 'Test overview 1',
      'poster_path': '/test1.jpg',
      'backdrop_path': '/test1_backdrop.jpg',
      'release_date': '2024-01-01',
      'vote_average': 8.0,
      'vote_count': 100,
      'genre_ids': [28, 12],
      'adult': false,
      'original_language': 'en',
      'original_title': 'Test Original Movie 1',
      'popularity': 100.0,
      'video': false,
    };

    final testMovieJson2 = {
      'id': 2,
      'title': 'Test Movie 2',
      'overview': 'Test overview 2',
      'poster_path': '/test2.jpg',
      'backdrop_path': '/test2_backdrop.jpg',
      'release_date': '2024-01-02',
      'vote_average': 7.5,
      'vote_count': 200,
      'genre_ids': [35, 18],
      'adult': false,
      'original_language': 'en',
      'original_title': 'Test Original Movie 2',
      'popularity': 90.0,
      'video': false,
    };

    final testResponseData = {
      'page': 1,
      'results': [testMovieJson1, testMovieJson2],
      'total_pages': 10,
      'total_results': 200,
    };

    final testResponse = Response(
      data: testResponseData,
      statusCode: 200,
      requestOptions: RequestOptions(path: '/movie/popular'),
    );

    group('getPopularMovies', () {
      test(
        'should return ApiResponse with movies when API call succeeds',
        () async {
          // Arrange
          when(
            mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
          ).thenAnswer((_) async => testResponse);

          // Act
          final result = await dataSource.getPopularMovies(page: 1);

          // Assert
          expect(result, isA<ApiResponse<List<Movie>>>());
          expect(result.page, 1);
          expect(result.totalPages, 10);
          expect(result.totalResults, 200);
          expect(result.resultsList?.length, 2);

          final movies = result.resultsList!;
          expect(movies[0].id, 1);
          expect(movies[0].title, 'Test Movie 1');
          expect(movies[0].overview, 'Test overview 1');
          expect(movies[0].posterPath, '/test1.jpg');
          expect(movies[0].voteAverage, 8.0);

          expect(movies[1].id, 2);
          expect(movies[1].title, 'Test Movie 2');
          expect(movies[1].voteAverage, 7.5);

          // Verify the correct API endpoint was called
          verify(
            mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
          ).called(1);
        },
      );

      test('should call API with correct page parameter', () async {
        // Arrange
        const testPage = 5;
        when(
          mockDioHelper.get(
            '/movie/popular',
            queryParameters: {'page': testPage},
          ),
        ).thenAnswer((_) async => testResponse);

        // Act
        await dataSource.getPopularMovies(page: testPage);

        // Assert
        verify(
          mockDioHelper.get(
            '/movie/popular',
            queryParameters: {'page': testPage},
          ),
        ).called(1);
      });

      test('should use default page 1 when no page specified', () async {
        // Arrange
        when(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).thenAnswer((_) async => testResponse);

        // Act
        await dataSource.getPopularMovies();

        // Assert
        verify(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).called(1);
      });

      test('should handle empty results array gracefully', () async {
        // Arrange
        final emptyResponse = Response(
          data: {
            'page': 1,
            'results': <Map<String, dynamic>>[],
            'total_pages': 0,
            'total_results': 0,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/popular'),
        );

        when(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).thenAnswer((_) async => emptyResponse);

        // Act
        final result = await dataSource.getPopularMovies(page: 1);

        // Assert
        expect(result.resultsList, isEmpty);
        expect(result.page, 1);
        expect(result.totalPages, 0);
        expect(result.totalResults, 0);
      });

      test('should throw FailException when DioException occurs', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/movie/popular'),
          response: Response(
            requestOptions: RequestOptions(path: '/movie/popular'),
            statusCode: 404,
            data: {
              'status_message':
                  'The resource you requested could not be found.',
            },
          ),
          type: DioExceptionType.badResponse,
        );

        when(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).thenThrow(dioException);

        // Act & Assert
        expect(
          () => dataSource.getPopularMovies(page: 1),
          throwsA(isA<FailException>()),
        );

        verify(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).called(1);
      });

      test(
        'should throw FailException when connection timeout occurs',
        () async {
          // Arrange
          final timeoutException = DioException(
            requestOptions: RequestOptions(path: '/movie/popular'),
            type: DioExceptionType.connectionTimeout,
          );

          when(
            mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
          ).thenThrow(timeoutException);

          // Act & Assert
          expect(
            () => dataSource.getPopularMovies(page: 1),
            throwsA(isA<FailException>()),
          );
        },
      );

      test('should handle missing results field gracefully', () async {
        // Arrange
        final malformedResponse = Response(
          data: {
            'page': 1,
            'total_pages': 0,
            'total_results': 0,
            // Missing 'results' field
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/popular'),
        );

        when(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).thenAnswer((_) async => malformedResponse);

        // Act
        final result = await dataSource.getPopularMovies(page: 1);

        // Assert
        expect(result.resultsList, isEmpty);
        expect(result.page, 1);
      });

      test('should handle null results array gracefully', () async {
        // Arrange
        final nullResultsResponse = Response(
          data: {
            'page': 1,
            'results': null,
            'total_pages': 0,
            'total_results': 0,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/movie/popular'),
        );

        when(
          mockDioHelper.get('/movie/popular', queryParameters: {'page': 1}),
        ).thenAnswer((_) async => nullResultsResponse);

        // Act
        final result = await dataSource.getPopularMovies(page: 1);

        // Assert
        expect(result.resultsList, isEmpty);
        expect(result.page, 1);
      });
    });
  });
}
