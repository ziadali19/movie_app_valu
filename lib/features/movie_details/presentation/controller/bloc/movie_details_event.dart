abstract class MovieDetailsEvent {}

/// Load movie details for a specific movie ID
class LoadMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  LoadMovieDetailsEvent({required this.movieId});
}

/// Retry loading movie details after an error
class RetryLoadingMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  RetryLoadingMovieDetailsEvent({required this.movieId});
}
