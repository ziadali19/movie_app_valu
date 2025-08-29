import '../../../favorites/data/models/favorite_movie.dart';

enum FavoritesStatus { initial, loading, success, error }

class FavoritesState {
  final FavoritesStatus status;
  final List<FavoriteMovie> favorites;
  final String? errorMessage;
  final Map<int, bool> favoriteStatus; // movieId -> isFavorite
  final int favoritesCount;
  final String searchQuery;
  final List<FavoriteMovie> searchResults;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.errorMessage,
    this.favoriteStatus = const {},
    this.favoritesCount = 0,
    this.searchQuery = '',
    this.searchResults = const [],
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteMovie>? favorites,
    String? errorMessage,
    Map<int, bool>? favoriteStatus,
    int? favoritesCount,
    String? searchQuery,
    List<FavoriteMovie>? searchResults,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  // Helper getters
  bool get isInitial => status == FavoritesStatus.initial;
  bool get isLoading => status == FavoritesStatus.loading;
  bool get isSuccess => status == FavoritesStatus.success;
  bool get hasError => status == FavoritesStatus.error;
  bool get hasFavorites => favorites.isNotEmpty;
  bool get isEmpty => favorites.isEmpty && !isLoading;
  bool get isSearching => searchQuery.isNotEmpty;
  bool get hasSearchResults => searchResults.isNotEmpty;

  /// Check if a movie is favorite
  bool isFavorite(int movieId) {
    return favoriteStatus[movieId] ?? false;
  }

  /// Get display list (search results if searching, otherwise all favorites)
  List<FavoriteMovie> get displayList {
    return isSearching ? searchResults : favorites;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoritesState &&
        other.status == status &&
        other.favorites.length == favorites.length &&
        other.errorMessage == errorMessage &&
        other.favoriteStatus.length == favoriteStatus.length &&
        other.favoritesCount == favoritesCount &&
        other.searchQuery == searchQuery &&
        other.searchResults.length == searchResults.length;
  }

  @override
  int get hashCode => Object.hash(
    status,
    favorites.length,
    errorMessage,
    favoriteStatus.length,
    favoritesCount,
    searchQuery,
    searchResults.length,
  );

  @override
  String toString() {
    return 'FavoritesState{status: $status, favoritesCount: $favoritesCount,favoriteStatus: $favoriteStatus, searchQuery: $searchQuery, errorMessage: $errorMessage}';
  }
}
