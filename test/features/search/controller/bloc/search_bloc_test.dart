import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';

import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/search/controller/bloc/search_bloc.dart';
import 'package:movie_app_valu/features/search/controller/bloc/search_event.dart';
import 'package:movie_app_valu/features/search/controller/bloc/search_state.dart';
import 'package:movie_app_valu/features/search/data/repository/search_repository.dart';

import 'search_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BaseSearchRepository>()])
void main() {
  group('SearchBloc Tests', () {
    late SearchBloc searchBloc;
    late MockBaseSearchRepository mockRepository;

    setUp(() {
      mockRepository = MockBaseSearchRepository();
      searchBloc = SearchBloc(mockRepository);
    });

    tearDown(() async {
      await searchBloc.close();
    });

    final testMovies = [
      Movie(
        id: 1,
        title: 'Alpha',
        overview: 'o1',
        posterPath: '/p1.jpg',
        releaseDate: '2024-01-01',
        voteAverage: 8.0,
        voteCount: 100,
        adult: false,
        genreIds: const [28],
        originalLanguage: 'en',
        originalTitle: 'Alpha',
        popularity: 10,
        video: false,
      ),
      Movie(
        id: 2,
        title: 'Beta',
        overview: 'o2',
        posterPath: '/p2.jpg',
        releaseDate: '2023-01-01',
        voteAverage: 7.0,
        voteCount: 90,
        adult: false,
        genreIds: const [12],
        originalLanguage: 'en',
        originalTitle: 'Beta',
        popularity: 9,
        video: false,
      ),
    ];

    ApiResponse<List<Movie>> buildResponse({
      required int page,
      required int totalPages,
      List<Movie>? results,
    }) {
      final list = results ?? testMovies;
      return ApiResponse<List<Movie>>.fromTMDBPaginated(
        json: {
          'page': page,
          'results': list.map((m) => m.toJson()).toList(),
          'total_pages': totalPages,
          'total_results': 200,
        },
        results: list,
        statusCode: 200,
      );
    }

    final testErrorModel = ApiErrorModel(
      message: 'Network error occurred',
      status: false,
    );

    test('initial state should be correct', () {
      expect(searchBloc.state, const SearchState());
      expect(searchBloc.state.status, SearchStatus.initial);
      expect(searchBloc.state.movies, isEmpty);
      expect(searchBloc.state.currentPage, 1);
      expect(searchBloc.state.hasMorePages, true);
      expect(searchBloc.state.isLoadingMore, false);
      expect(searchBloc.state.errorMessage, isNull);
    });

    group('SearchMoviesEvent', () {
      blocTest<SearchBloc, SearchState>(
        'emits [searching, success] on success',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 1),
          ).thenAnswer(
            (_) async => Right(buildResponse(page: 1, totalPages: 10)),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(SearchMoviesEvent(query: 'batman')),
        expect: () => [
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.searching)
              .having((s) => s.movies.length, 'movies length', 0)
              .having((s) => s.query, 'query', 'batman')
              .having((s) => s.currentPage, 'currentPage', 1),
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.success)
              .having((s) => s.movies.length, 'movies length', 2)
              .having((s) => s.currentPage, 'currentPage', 1)
              .having((s) => s.hasMorePages, 'hasMorePages', true)
              .having((s) => s.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(
            mockRepository.searchMovies(query: 'batman', page: 1),
          ).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits [searching, error] on error',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 1),
          ).thenAnswer((_) async => Left(testErrorModel));
          return searchBloc;
        },
        act: (bloc) => bloc.add(SearchMoviesEvent(query: 'batman')),
        expect: () => [
          isA<SearchState>().having(
            (s) => s.status,
            'status',
            SearchStatus.searching,
          ),
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.error)
              .having((s) => s.movies.length, 'movies length', 0)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Network error occurred',
              ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'sets hasMorePages=false when last page',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 1),
          ).thenAnswer(
            (_) async => Right(buildResponse(page: 10, totalPages: 10)),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(SearchMoviesEvent(query: 'batman')),
        expect: () => [
          isA<SearchState>().having(
            (s) => s.status,
            'status',
            SearchStatus.searching,
          ),
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.success)
              .having((s) => s.currentPage, 'currentPage', 10)
              .having((s) => s.hasMorePages, 'hasMorePages', false),
        ],
      );
    });

    group('LoadMoreSearchResultsEvent', () {
      blocTest<SearchBloc, SearchState>(
        'appends new items and updates page',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 2),
          ).thenAnswer(
            (_) async => Right(
              buildResponse(
                page: 2,
                totalPages: 10,
                results: [
                  Movie(
                    id: 3,
                    title: 'Gamma',
                    overview: 'o3',
                    posterPath: '/p3.jpg',
                    releaseDate: '2022-01-01',
                    voteAverage: 6.5,
                    voteCount: 70,
                    adult: false,
                    genreIds: const [12],
                    originalLanguage: 'en',
                    originalTitle: 'Gamma',
                    popularity: 7,
                    video: false,
                  ),
                ],
              ),
            ),
          );
          return searchBloc;
        },
        seed: () => const SearchState(
          status: SearchStatus.success,
          movies: [],
          query: 'batman',
          currentPage: 1,
          hasMorePages: true,
          isLoadingMore: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreSearchResultsEvent()),
        expect: () => [
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.success)
              .having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.success)
              .having((s) => s.movies.length, 'movies length', 1)
              .having((s) => s.currentPage, 'currentPage', 2)
              .having((s) => s.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(
            mockRepository.searchMovies(query: 'batman', page: 2),
          ).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits error on load more failure',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 2),
          ).thenAnswer((_) async => Left(testErrorModel));
          return searchBloc;
        },
        seed: () => const SearchState(
          status: SearchStatus.success,
          movies: [],
          query: 'batman',
          currentPage: 1,
          hasMorePages: true,
          isLoadingMore: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreSearchResultsEvent()),
        expect: () => [
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.success)
              .having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.error)
              .having((s) => s.isLoadingMore, 'isLoadingMore', false)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Network error occurred',
              ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'does not load more when hasMorePages is false',
        build: () => searchBloc,
        seed: () => const SearchState(
          status: SearchStatus.success,
          movies: [],
          query: 'batman',
          currentPage: 10,
          hasMorePages: false,
          isLoadingMore: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreSearchResultsEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(
            mockRepository.searchMovies(
              query: anyNamed('query'),
              page: anyNamed('page'),
            ),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'does not load more when already loading',
        build: () => searchBloc,
        seed: () => const SearchState(
          status: SearchStatus.success,
          movies: [],
          query: 'batman',
          currentPage: 1,
          hasMorePages: true,
          isLoadingMore: true,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(LoadMoreSearchResultsEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(
            mockRepository.searchMovies(
              query: anyNamed('query'),
              page: anyNamed('page'),
            ),
          );
        },
      );
    });

    group('Clear & Retry', () {
      blocTest<SearchBloc, SearchState>(
        'ClearSearchEvent resets to initial',
        build: () => searchBloc,
        seed: () => const SearchState(
          status: SearchStatus.success,
          movies: [],
          query: 'batman',
          currentPage: 2,
          hasMorePages: true,
          isLoadingMore: false,
          errorMessage: null,
        ),
        act: (bloc) => bloc.add(ClearSearchEvent()),
        expect: () => [
          isA<SearchState>()
              .having((s) => s.status, 'status', SearchStatus.initial)
              .having((s) => s.movies.length, 'movies length', 0)
              .having((s) => s.query, 'query', ''),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'RetrySearchEvent retriggers current query',
        build: () {
          when(
            mockRepository.searchMovies(query: 'batman', page: 1),
          ).thenAnswer(
            (_) async => Right(buildResponse(page: 1, totalPages: 10)),
          );
          return searchBloc;
        },
        seed: () => const SearchState(
          status: SearchStatus.error,
          movies: [],
          query: 'batman',
          currentPage: 1,
          hasMorePages: true,
          isLoadingMore: false,
          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(RetrySearchEvent()),
        expect: () => [
          isA<SearchState>().having(
            (s) => s.status,
            'status',
            SearchStatus.searching,
          ),
          isA<SearchState>().having(
            (s) => s.status,
            'status',
            SearchStatus.success,
          ),
        ],
      );
    });
  });
}
