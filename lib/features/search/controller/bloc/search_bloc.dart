import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:rxdart/rxdart.dart';

import '../../../movies/data/models/movie.dart';
import '../../data/repository/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

typedef EventMapper<E> = Stream<void> Function(E event);

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BaseSearchRepository repository;
  String? _lastQuery;

  static const Duration _debounceDuration = Duration(milliseconds: 500);

  SearchBloc(this.repository) : super(const SearchState()) {
    on<SearchMoviesEvent>(
      _onSearchMovies,
      transformer: debounceRestartable<SearchMoviesEvent>(_debounceDuration),
    );
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
    on<RetrySearchEvent>(_onRetrySearch);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    // If query is empty, clear results
    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.initial,
          movies: [],
          query: '',
          errorMessage: null,
          currentPage: 1,
          hasMorePages: true,
        ),
      );
      return;
    }

    // If same query and we have results, don't search again
    if (event.query.trim() == _lastQuery && state.hasResults) {
      return;
    }

    _lastQuery = event.query.trim();

    emit(
      state.copyWith(
        status: SearchStatus.searching,
        query: event.query.trim(),
        movies: [],
        currentPage: 1,
        hasMorePages: true,
        errorMessage: null,
      ),
    );

    await _performSearch(event.query.trim(), 1, emit);
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMorePages || state.query.isEmpty) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await repository.searchMovies(
      query: state.query,
      page: nextPage,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: SearchStatus.error,

          errorMessage: error.message ?? 'Failed to load more results',
        ),
      ),
      (apiResponse) => _handleSuccessResponse(apiResponse, emit),
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    _lastQuery = null;
    emit(const SearchState());
  }

  Future<void> _onRetrySearch(
    RetrySearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.query.isNotEmpty) {
      add(SearchMoviesEvent(query: state.query));
    }
  }

  Future<void> _performSearch(
    String query,
    int page,
    Emitter<SearchState> emit,
  ) async {
    final result = await repository.searchMovies(query: query, page: page);

    // Check if emit is still valid before emitting
    if (!emit.isDone) {
      result.fold(
        (error) => emit(
          state.copyWith(
            status: SearchStatus.error,
            errorMessage: error.message ?? 'Search failed',
          ),
        ),
        (apiResponse) => _handleSuccessResponse(apiResponse, emit),
      );
    }
  }

  void _handleSuccessResponse(
    ApiResponse<List<Movie>> apiResponse,
    Emitter<SearchState> emit,
  ) {
    // Check if emit is still valid before emitting
    if (!emit.isDone) {
      final newMovies = apiResponse.results ?? [];
      final isLoadingMore = state.isLoadingMore;

      final currentPage = apiResponse.page ?? state.currentPage;
      final totalPages = apiResponse.totalPages ?? 1;
      final hasMorePages = currentPage < totalPages;

      emit(
        state.copyWith(
          status: SearchStatus.success,
          movies: isLoadingMore ? [...state.movies, ...newMovies] : newMovies,
          currentPage: currentPage,
          hasMorePages: hasMorePages,

          errorMessage: null,
        ),
      );
    }
  }
}
