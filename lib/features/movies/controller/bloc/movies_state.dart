import '../../data/models/movie.dart';

enum MoviesStatus { initial, loading, success, error, loadingMore }

class MoviesState {
  final MoviesStatus status;
  final List<Movie> movies;
  final String? errorMessage;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  const MoviesState({
    this.status = MoviesStatus.initial,
    this.movies = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
  });

  MoviesState copyWith({
    MoviesStatus? status,
    List<Movie>? movies,
    String? errorMessage,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
  }) {
    return MoviesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  // Helper getters
  bool get isLoading => status == MoviesStatus.loading;
  bool get hasError => status == MoviesStatus.error;
  bool get hasData => movies.isNotEmpty;
  bool get isInitial => status == MoviesStatus.initial;
  bool get isSuccess => status == MoviesStatus.success;
  bool get canLoadMore => hasMorePages && !isLoadingMore && !isLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoviesState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          movies == other.movies &&
          errorMessage == other.errorMessage &&
          currentPage == other.currentPage &&
          hasMorePages == other.hasMorePages &&
          isLoadingMore == other.isLoadingMore;

  @override
  int get hashCode =>
      status.hashCode ^
      movies.hashCode ^
      errorMessage.hashCode ^
      currentPage.hashCode ^
      hasMorePages.hashCode ^
      isLoadingMore.hashCode;

  @override
  String toString() {
    return 'MoviesState{status: $status, moviesCount: ${movies.length}, currentPage: $currentPage, hasMorePages: $hasMorePages, isLoadingMore: $isLoadingMore}';
  }
}
