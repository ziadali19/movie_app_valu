import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_bloc.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_event.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_state.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movies/data/repository/movies_repository.dart';

import 'movies_bloc_test.mocks.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<BaseMoviesRepository>()])
void main() {
  group('MoviesBloc Tests', () {
    late MoviesBloc moviesBloc;
    late MockBaseMoviesRepository mockRepository;

    setUp(() {
      mockRepository = MockBaseMoviesRepository();
      moviesBloc = MoviesBloc(mockRepository);
    });

    tearDown(() {
      moviesBloc.close();
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

    final testErrorModel = ApiErrorModel(
      message: 'Network error occurred',
      status: false,
    );

    test('initial state should be correct', () {
      expect(moviesBloc.state, const MoviesState());
      expect(moviesBloc.state.status, MoviesStatus.initial);
      expect(moviesBloc.state.movies, isEmpty);
      expect(moviesBloc.state.currentPage, 1);
      expect(moviesBloc.state.hasMorePages, true);
      expect(moviesBloc.state.isLoadingMore, false);
      expect(moviesBloc.state.errorMessage, isNull);
    });

    group('LoadMoviesEvent', () {
      blocTest<MoviesBloc, MoviesState>(
        'should emit [loading, success] when repository returns data successfully',
        build: () {
          when(
            mockRepository.getPopularMovies(page: 1),
          ).thenAnswer((_) async => Right(testApiResponse));
          return moviesBloc;
        },
        act: (bloc) => bloc.add(LoadMoviesEvent()),
        expect: () => [
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.loading)
              .having((state) => state.movies.length, 'movies length', 0),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 1)).called(1);
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'should emit [loading, error] when repository returns error',
        build: () {
          when(
            mockRepository.getPopularMovies(page: 1),
          ).thenAnswer((_) async => Left(testErrorModel));
          return moviesBloc;
        },
        act: (bloc) => bloc.add(LoadMoviesEvent()),
        expect: () => [
          isA<MoviesState>().having(
            (state) => state.status,
            'status',
            MoviesStatus.loading,
          ),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.error)
              .having((state) => state.movies.length, 'movies length', 0)
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Network error occurred',
              ),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 1)).called(1);
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'should set hasMorePages to false when on last page',
        build: () {
          final lastPageResponse = ApiResponse<List<Movie>>.fromTMDBPaginated(
            json: {
              'page': 10,
              'results': testMovies.map((movie) => movie.toJson()).toList(),
              'total_pages': 10,
              'total_results': 200,
            },
            results: testMovies,
            statusCode: 200,
          );

          when(
            mockRepository.getPopularMovies(page: 1),
          ).thenAnswer((_) async => Right(lastPageResponse));
          return moviesBloc;
        },
        act: (bloc) => bloc.add(LoadMoviesEvent()),
        expect: () => [
          isA<MoviesState>().having(
            (state) => state.status,
            'status',
            MoviesStatus.loading,
          ),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 10)
              .having((state) => state.hasMorePages, 'hasMorePages', false)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
      );
    });

    group('LoadMoreMoviesEvent', () {
      blocTest<MoviesBloc, MoviesState>(
        'should emit states with isLoadingMore true, then append new movies',
        build: () {
          final moreMovies = [
            Movie(
              id: 3,
              title: 'Test Movie 3',
              overview: 'Test overview 3',
              posterPath: '/test3.jpg',
              releaseDate: '2024-01-03',
              voteAverage: 7.0,
              voteCount: 150,
              adult: false,
              genreIds: [18],
              originalLanguage: 'en',
              originalTitle: 'Test Movie 3',
              popularity: 80.0,
              video: false,
            ),
          ];

          final moreMoviesResponse = ApiResponse<List<Movie>>.fromTMDBPaginated(
            json: {
              'page': 2,
              'results': moreMovies.map((movie) => movie.toJson()).toList(),
              'total_pages': 10,
              'total_results': 200,
            },
            results: moreMovies,
            statusCode: 200,
          );

          when(
            mockRepository.getPopularMovies(page: 2),
          ).thenAnswer((_) async => Right(moreMoviesResponse));
          return moviesBloc;
        },
        seed: () => MoviesState(
          status: MoviesStatus.success,
          movies: testMovies,
          currentPage: 1,
          hasMorePages: true,

          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreMoviesEvent()),
        expect: () => [
          isA<MoviesState>()
              .having(
                (state) => state.status,
                'status',
                MoviesStatus.loadingMore,
              )
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', true),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 3)
              .having((state) => state.currentPage, 'currentPage', 2)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 2)).called(1);
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'should emit error state when load more fails',
        build: () {
          when(
            mockRepository.getPopularMovies(page: 2),
          ).thenAnswer((_) async => Left(testErrorModel));
          return moviesBloc;
        },
        seed: () => MoviesState(
          status: MoviesStatus.success,
          movies: testMovies,
          currentPage: 1,
          hasMorePages: true,

          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreMoviesEvent()),
        expect: () => [
          isA<MoviesState>()
              .having(
                (state) => state.status,
                'status',
                MoviesStatus.loadingMore,
              )
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.isLoadingMore, 'isLoadingMore', true),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.error)
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false)
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Network error occurred',
              ),
        ],
      );

      blocTest<MoviesBloc, MoviesState>(
        'should not load more when hasMorePages is false',
        build: () => moviesBloc,
        seed: () => MoviesState(
          status: MoviesStatus.success,
          movies: testMovies,
          currentPage: 10,
          hasMorePages: false,

          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreMoviesEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(mockRepository.getPopularMovies(page: anyNamed('page')));
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'should not load more when already loading more',
        build: () => moviesBloc,
        seed: () => MoviesState(
          status: MoviesStatus.loadingMore,
          movies: testMovies,
          currentPage: 1,
          hasMorePages: true,

          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreMoviesEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(mockRepository.getPopularMovies(page: anyNamed('page')));
        },
      );
    });

    group('RefreshMoviesEvent', () {
      blocTest<MoviesBloc, MoviesState>(
        'should reset state and load first page',
        build: () {
          when(
            mockRepository.getPopularMovies(page: 1),
          ).thenAnswer((_) async => Right(testApiResponse));
          return moviesBloc;
        },
        seed: () => MoviesState(
          status: MoviesStatus.success,
          movies: testMovies,
          currentPage: 3,
          hasMorePages: true,

          errorMessage: null,
        ),
        act: (bloc) => bloc.add(RefreshMoviesEvent()),
        expect: () => [
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.loading)
              .having(
                (state) => state.movies.length,
                'movies length',
                2,
              ) // Keeps existing movies during loading
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 1)).called(1);
        },
      );
    });

    group('RetryLoadingMoviesEvent', () {
      blocTest<MoviesBloc, MoviesState>(
        'should retry loading movies by dispatching LoadMoviesEvent when no data',
        build: () {
          when(
            mockRepository.getPopularMovies(page: 1),
          ).thenAnswer((_) async => Right(testApiResponse));
          return moviesBloc;
        },
        seed: () => const MoviesState(
          status: MoviesStatus.error,
          movies: [], // No data, so should dispatch LoadMoviesEvent
          currentPage: 1,
          hasMorePages: true,

          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(RetryLoadingMoviesEvent()),
        expect: () => [
          // Same as LoadMoviesEvent since RetryLoadingMoviesEvent dispatches LoadMoviesEvent
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.loading)
              .having((state) => state.movies.length, 'movies length', 0)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 1)).called(1);
        },
      );

      blocTest<MoviesBloc, MoviesState>(
        'should retry loading movies by dispatching LoadMoreMoviesEvent when has data',
        build: () {
          final moreMovies = [
            Movie(
              id: 3,
              title: 'Test Movie 3',
              overview: 'Test overview 3',
              posterPath: '/test3.jpg',
              releaseDate: '2024-01-03',
              voteAverage: 7.0,
              voteCount: 150,
              adult: false,
              genreIds: [18],
              originalLanguage: 'en',
              originalTitle: 'Test Movie 3',
              popularity: 80.0,
              video: false,
            ),
          ];

          final moreMoviesResponse = ApiResponse<List<Movie>>.fromTMDBPaginated(
            json: {
              'page': 2,
              'results': moreMovies.map((movie) => movie.toJson()).toList(),
              'total_pages': 10,
              'total_results': 200,
            },
            results: moreMovies,
            statusCode: 200,
          );

          when(
            mockRepository.getPopularMovies(page: 2),
          ).thenAnswer((_) async => Right(moreMoviesResponse));
          return moviesBloc;
        },
        seed: () => MoviesState(
          status: MoviesStatus.error,
          movies:
              testMovies, // Has data, so should dispatch LoadMoreMoviesEvent
          currentPage: 1,
          hasMorePages: true,

          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(RetryLoadingMoviesEvent()),
        expect: () => [
          // Same as LoadMoreMoviesEvent since RetryLoadingMoviesEvent dispatches LoadMoreMoviesEvent
          isA<MoviesState>()
              .having(
                (state) => state.status,
                'status',
                MoviesStatus.loadingMore,
              )
              .having((state) => state.movies.length, 'movies length', 2)
              .having((state) => state.currentPage, 'currentPage', 1)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', true),
          isA<MoviesState>()
              .having((state) => state.status, 'status', MoviesStatus.success)
              .having((state) => state.movies.length, 'movies length', 3)
              .having((state) => state.currentPage, 'currentPage', 2)
              .having((state) => state.hasMorePages, 'hasMorePages', true)
              .having((state) => state.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getPopularMovies(page: 2)).called(1);
        },
      );
    });
  });
}
