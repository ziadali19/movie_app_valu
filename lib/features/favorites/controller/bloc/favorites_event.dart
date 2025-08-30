import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';

abstract class FavoritesEvent {}

/// Load all favorites from local storage
class LoadFavoritesEvent extends FavoritesEvent {}

/// Add a movie to favorites
class AddToFavoritesEvent extends FavoritesEvent {
  final Movie movie;

  AddToFavoritesEvent({required this.movie});
}

/// Add a movie details to favorites
class AddMovieDetailsToFavoritesEvent extends FavoritesEvent {
  final MovieDetails movieDetails;

  AddMovieDetailsToFavoritesEvent({required this.movieDetails});
}

/// Remove a movie from favorites
class RemoveFromFavoritesEvent extends FavoritesEvent {
  final int movieId;

  RemoveFromFavoritesEvent({required this.movieId});
}

/// Toggle favorite status (smart add/remove)
class ToggleFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  ToggleFavoriteEvent({required this.movie});
}

/// Toggle favorite status from movie details
class ToggleFavoriteFromDetailsEvent extends FavoritesEvent {
  final MovieDetails movieDetails;

  ToggleFavoriteFromDetailsEvent({required this.movieDetails});
}

/// Check if a movie is favorite
class CheckFavoriteStatusEvent extends FavoritesEvent {
  final int movieId;

  CheckFavoriteStatusEvent({required this.movieId});
}

/// Search within favorites
class SearchFavoritesEvent extends FavoritesEvent {
  final String query;

  SearchFavoritesEvent({required this.query});
}

/// Clear all favorites
class ClearAllFavoritesEvent extends FavoritesEvent {}

/// Refresh favorites (reload from storage)
class RefreshFavoritesEvent extends FavoritesEvent {}

/// Load favorites count
class LoadFavoritesCountEvent extends FavoritesEvent {}
