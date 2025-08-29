import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/search/data/remote_data_source/search_remote_data_source.dart';

import 'search_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DioHelper>()])
void main() {
  group('SearchRemoteDataSource Tests', () {
    late MockDioHelper mockDioHelper;
    late SearchRemoteDataSource dataSource;

    setUp(() {
      mockDioHelper = MockDioHelper();
      dataSource = SearchRemoteDataSource(mockDioHelper);
    });

    final testMovieJson = {
      'id': 1,
      'title': 'A',
      'overview': '',
      'poster_path': null,
      'backdrop_path': null,
      'vote_average': 7.1,
      'vote_count': 11,
      'release_date': '2020-01-01',
      'genre_ids': <int>[],
      'adult': false,
      'original_language': 'en',
      'original_title': 'A',
      'popularity': 1.0,
      'video': false,
    };

    final testResponseData = {
      'page': 1,
      'results': [testMovieJson],
      'total_pages': 5,
      'total_results': 100,
    };

    final testResponse = Response(
      data: testResponseData,
      statusCode: 200,
      requestOptions: RequestOptions(path: '/search/movie'),
    );

    test(
      'should return ApiResponse with movies when API call succeeds',
      () async {
        when(
          mockDioHelper.get(
            '/search/movie',
            queryParameters: {'query': 'a', 'page': 1},
          ),
        ).thenAnswer((_) async => testResponse);

        final res = await dataSource.searchMovies(query: 'a', page: 1);
        expect(res, isA<ApiResponse<List<Movie>>>());
        expect(res.page, 1);
        expect(res.totalPages, 5);
        expect(res.totalResults, 100);
        expect(res.results?.length, 1);
      },
    );

    test('should call API with correct page and query', () async {
      when(
        mockDioHelper.get(
          '/search/movie',
          queryParameters: {'query': 'batman', 'page': 3},
        ),
      ).thenAnswer((_) async => testResponse);

      await dataSource.searchMovies(query: 'batman', page: 3);

      verify(
        mockDioHelper.get(
          '/search/movie',
          queryParameters: {'query': 'batman', 'page': 3},
        ),
      ).called(1);
    });

    test('should handle empty results gracefully', () async {
      final emptyResponse = Response(
        data: {
          'page': 1,
          'results': <Map<String, dynamic>>[],
          'total_pages': 0,
          'total_results': 0,
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/search/movie'),
      );

      when(
        mockDioHelper.get(
          '/search/movie',
          queryParameters: {'query': 'a', 'page': 1},
        ),
      ).thenAnswer((_) async => emptyResponse);

      final res = await dataSource.searchMovies(query: 'a', page: 1);
      expect(res.results, isEmpty);
      expect(res.totalPages, 0);
    });

    test('should throw FailException on DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/search/movie'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/search/movie'),
          statusCode: 404,
          data: {'status_message': 'not found'},
        ),
      );

      when(
        mockDioHelper.get(
          '/search/movie',
          queryParameters: {'query': 'a', 'page': 1},
        ),
      ).thenThrow(dioException);

      expect(
        () => dataSource.searchMovies(query: 'a', page: 1),
        throwsA(isA<FailException>()),
      );
    });
  });
}
