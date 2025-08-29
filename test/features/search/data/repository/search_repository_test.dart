import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/search/data/remote_data_source/search_remote_data_source.dart';
import 'package:movie_app_valu/features/search/data/repository/search_repository.dart';

import 'search_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BaseSearchRemoteDataSource>()])
void main() {
  group('SearchRepository Tests', () {
    late SearchRepository repository;
    late MockBaseSearchRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockBaseSearchRemoteDataSource();
      repository = SearchRepository(mockRemoteDataSource);
    });

    final testMovies = [
      Movie(
        id: 1,
        title: 'A',
        overview: '',
        posterPath: null,
        releaseDate: '2020-01-01',
        voteAverage: 7.1,
        voteCount: 11,
        adult: false,
        genreIds: const [],
        originalLanguage: 'en',
        originalTitle: 'A',
        popularity: 1.0,
        video: false,
      ),
      Movie(
        id: 2,
        title: 'B',
        overview: '',
        posterPath: null,
        releaseDate: '2021-01-01',
        voteAverage: 6.2,
        voteCount: 12,
        adult: false,
        genreIds: const [],
        originalLanguage: 'en',
        originalTitle: 'B',
        popularity: 2.0,
        video: false,
      ),
    ];

    final testApiResponse = ApiResponse<List<Movie>>(
      status: 200,
      success: true,
      page: 1,
      results: testMovies,
      totalPages: 10,
      totalResults: 100,
    );

    test('should return Right with ApiResponse when remote succeeds', () async {
      when(
        mockRemoteDataSource.searchMovies(query: 'batman', page: 1),
      ).thenAnswer((_) async => testApiResponse);

      final result = await repository.searchMovies(query: 'batman', page: 1);

      expect(result, isA<Right<ApiErrorModel, ApiResponse<List<Movie>>>>());
      result.fold((l) => fail('Expected Right'), (r) {
        expect(r.results?.length, 2);
        expect(r.page, 1);
        expect(r.totalPages, 10);
      });
    });

    test(
      'should return Left with ApiErrorModel when FailException thrown',
      () async {
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
          mockRemoteDataSource.searchMovies(query: 'batman', page: 1),
        ).thenThrow(FailException(exception: dioException));

        final result = await repository.searchMovies(query: 'batman', page: 1);

        expect(result, isA<Left<ApiErrorModel, ApiResponse<List<Movie>>>>());
        result.fold(
          (l) => expect(l, isA<ApiErrorModel>()),
          (r) => fail('Expected Left'),
        );
      },
    );

    test('should call remote with correct params', () async {
      when(
        mockRemoteDataSource.searchMovies(query: 'batman', page: 3),
      ).thenAnswer((_) async => testApiResponse);

      await repository.searchMovies(query: 'batman', page: 3);

      verify(
        mockRemoteDataSource.searchMovies(query: 'batman', page: 3),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
