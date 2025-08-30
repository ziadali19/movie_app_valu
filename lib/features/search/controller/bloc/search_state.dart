import '../../../movies/data/models/movie.dart';

enum SearchStatus { initial, searching, success, error, loadingMore }

class SearchState {
  final SearchStatus status;
  final List<Movie> movies;
  final String query;
  final String? errorMessage;
  final int currentPage;
  final bool hasMorePages;

  const SearchState({
    this.status = SearchStatus.initial,
    this.movies = const [],
    this.query = '',
    this.errorMessage,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Movie>? movies,
    String? query,
    String? errorMessage,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return SearchState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  // Helper getters
  bool get isSearching => status == SearchStatus.searching;
  bool get hasError => status == SearchStatus.error;
  bool get hasResults => movies.isNotEmpty;
  bool get isInitial => status == SearchStatus.initial;
  bool get isSuccess => status == SearchStatus.success;
  bool get isLoadingMore => status == SearchStatus.loadingMore;
  bool get canLoadMore =>
      hasMorePages && !isLoadingMore && !isSearching && query.isNotEmpty;
  bool get isEmpty =>
      status == SearchStatus.success && movies.isEmpty && query.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          movies == other.movies &&
          query == other.query &&
          errorMessage == other.errorMessage &&
          currentPage == other.currentPage &&
          hasMorePages == other.hasMorePages;

  @override
  int get hashCode =>
      status.hashCode ^
      movies.hashCode ^
      query.hashCode ^
      errorMessage.hashCode ^
      currentPage.hashCode ^
      hasMorePages.hashCode;

  @override
  String toString() {
    return 'SearchState{status: $status, moviesCount: ${movies.length}, query: "$query", currentPage: $currentPage, hasMorePages: $hasMorePages}';
  }
}
