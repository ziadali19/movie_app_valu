import '../../data/models/movie.dart';

enum MoviesStatus { initial, loading, success, error, loadingMore }

class MoviesState {
  final MoviesStatus status;
  final List<Movie> movies;
  final String? errorMessage;
  final int currentPage;
  final bool hasMorePages;

  const MoviesState({
    this.status = MoviesStatus.initial,
    this.movies = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  MoviesState copyWith({
    MoviesStatus? status,
    List<Movie>? movies,
    String? errorMessage,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return MoviesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  // Helper getters
  bool get isLoading => status == MoviesStatus.loading;
  bool get hasError => status == MoviesStatus.error;
  bool get hasData => movies.isNotEmpty;
  bool get isInitial => status == MoviesStatus.initial;
  bool get isSuccess => status == MoviesStatus.success;
  bool get isLoadingMore => status == MoviesStatus.loadingMore;
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
          hasMorePages == other.hasMorePages;

  @override
  int get hashCode =>
      status.hashCode ^
      movies.hashCode ^
      errorMessage.hashCode ^
      currentPage.hashCode ^
      hasMorePages.hashCode;

  @override
  String toString() {
    return 'MoviesState{status: $status, moviesCount: ${movies.length}, currentPage: $currentPage, hasMorePages: $hasMorePages}';
  }
}
