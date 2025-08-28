abstract class MoviesEvent {}

/// Load initial popular movies (page 1)
class LoadMoviesEvent extends MoviesEvent {}

/// Load more movies for pagination (next page)
class LoadMoreMoviesEvent extends MoviesEvent {}

/// Refresh movies list (pull to refresh)
class RefreshMoviesEvent extends MoviesEvent {}

/// Retry loading movies after an error
class RetryLoadingMoviesEvent extends MoviesEvent {}
