import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';

import '../../data/models/movie.dart';
import '../../data/repository/movies_repository.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final BaseMoviesRepository repository;

  MoviesBloc(this.repository) : super(const MoviesState()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
    on<RefreshMoviesEvent>(_onRefreshMovies);
    on<RetryLoadingMoviesEvent>(_onRetryLoadingMovies);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(status: MoviesStatus.loading));

    final result = await repository.getPopularMovies(page: 1);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: MoviesStatus.error,
          errorMessage: error.message ?? 'Failed to load movies',
        ),
      ),
      (apiResponse) =>
          _handleSuccessResponse(apiResponse, emit, isInitialLoad: true),
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (!state.canLoadMore) return;

    emit(state.copyWith(status: MoviesStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await repository.getPopularMovies(page: nextPage);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: MoviesStatus.error,

          errorMessage: error.message ?? 'Failed to load more movies',
        ),
      ),
      (apiResponse) => _handleSuccessResponse(apiResponse, emit),
    );
  }

  Future<void> _onRefreshMovies(
    RefreshMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MoviesStatus.loading,
        currentPage: 1,
        hasMorePages: true,
        errorMessage: null,
      ),
    );

    final result = await repository.getPopularMovies(page: 1);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: MoviesStatus.error,
          errorMessage: error.message ?? 'Failed to refresh movies',
        ),
      ),
      (apiResponse) =>
          _handleSuccessResponse(apiResponse, emit, isInitialLoad: true),
    );
  }

  Future<void> _onRetryLoadingMovies(
    RetryLoadingMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (state.hasData) {
      // If we have data, try to load more
      add(LoadMoreMoviesEvent());
    } else {
      // If no data, try initial load
      add(LoadMoviesEvent());
    }
  }

  void _handleSuccessResponse(
    ApiResponse<List<Movie>> apiResponse,
    Emitter<MoviesState> emit, {
    bool isInitialLoad = false,
  }) {
    final newMovies = apiResponse.results ?? <Movie>[];
    final currentMovies = isInitialLoad ? <Movie>[] : state.movies;
    final allMovies = [...currentMovies, ...newMovies];

    emit(
      state.copyWith(
        status: MoviesStatus.success,
        movies: allMovies,
        currentPage: apiResponse.page ?? state.currentPage,
        hasMorePages: apiResponse.hasNextPage,

        errorMessage: null, // Clear any previous errors
      ),
    );
  }
}
