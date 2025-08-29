import '../../../movie_details/data/models/movie_details.dart';

enum MovieDetailsStatus { initial, loading, success, error }

class MovieDetailsState {
  final MovieDetailsStatus status;
  final MovieDetails? movieDetails;
  final String? errorMessage;
  final int? movieId;

  const MovieDetailsState({
    this.status = MovieDetailsStatus.initial,
    this.movieDetails,
    this.errorMessage,
    this.movieId,
  });

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    MovieDetails? movieDetails,
    String? errorMessage,
    int? movieId,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      movieDetails: movieDetails ?? this.movieDetails,
      errorMessage: errorMessage,
      movieId: movieId ?? this.movieId,
    );
  }

  // Helper getters
  bool get isInitial => status == MovieDetailsStatus.initial;
  bool get isLoading => status == MovieDetailsStatus.loading;
  bool get isSuccess => status == MovieDetailsStatus.success;
  bool get hasError => status == MovieDetailsStatus.error;
  bool get hasData => movieDetails != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieDetailsState &&
        other.status == status &&
        other.movieDetails == movieDetails &&
        other.errorMessage == errorMessage &&
        other.movieId == movieId;
  }

  @override
  int get hashCode => Object.hash(status, movieDetails, errorMessage, movieId);

  @override
  String toString() {
    return 'MovieDetailsState{status: $status, hasData: $hasData, movieId: $movieId, errorMessage: $errorMessage}';
  }
}
