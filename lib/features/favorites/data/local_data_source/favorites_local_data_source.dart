import 'package:hive/hive.dart';
import '../models/favorite_movie.dart';

abstract class BaseFavoritesLocalDataSource {
  Future<List<FavoriteMovie>> getAllFavorites();
  Future<void> addToFavorites(FavoriteMovie movie);
  Future<void> removeFromFavorites(int movieId);
  Future<bool> isFavorite(int movieId);
  Future<void> clearAllFavorites();
  Future<int> getFavoritesCount();
  Future<List<FavoriteMovie>> searchFavorites(String query);
  Future<List<FavoriteMovie>> getFavoritesPaginated({
    int page = 1,
    int limit = 20,
  });
  Future<FavoriteMovie?> getFavoriteById(int movieId);
  Future<Map<String, dynamic>> exportFavorites();
  Future<void> compact();
}

class FavoritesLocalDataSource implements BaseFavoritesLocalDataSource {
  static const String _favoritesBoxName = 'favorites';

  Box<FavoriteMovie>? _favoritesBox;

  // Initialize the Hive box
  Future<void> init() async {
    if (_favoritesBox == null || !_favoritesBox!.isOpen) {
      _favoritesBox = await Hive.openBox<FavoriteMovie>(_favoritesBoxName);
    }
  }

  // Ensure box is open before operations
  Future<Box<FavoriteMovie>> _getBox() async {
    await init();
    return _favoritesBox!;
  }

  @override
  Future<List<FavoriteMovie>> getAllFavorites() async {
    try {
      final box = await _getBox();

      // Return all favorites sorted by addedAt (newest first)
      final favorites = box.values.toList();
      favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));

      return favorites;
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<void> addToFavorites(FavoriteMovie movie) async {
    try {
      final box = await _getBox();

      // Use movie ID as key for easy retrieval and uniqueness
      await box.put(movie.id, movie);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(int movieId) async {
    try {
      final box = await _getBox();

      if (box.containsKey(movieId)) {
        await box.delete(movieId);
      }
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    try {
      final box = await _getBox();
      return box.containsKey(movieId);
    } catch (e) {
      // Return false if there's an error checking favorite status
      return false;
    }
  }

  @override
  Future<void> clearAllFavorites() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final box = await _getBox();
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  // Get a specific favorite by ID
  @override
  Future<FavoriteMovie?> getFavoriteById(int movieId) async {
    try {
      final box = await _getBox();
      return box.get(movieId);
    } catch (e) {
      return null;
    }
  }

  // Get favorites with pagination (for large datasets)
  @override
  Future<List<FavoriteMovie>> getFavoritesPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final allFavorites = await getAllFavorites();
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      if (startIndex >= allFavorites.length) {
        return [];
      }

      return allFavorites.sublist(
        startIndex,
        endIndex > allFavorites.length ? allFavorites.length : endIndex,
      );
    } catch (e) {
      throw Exception('Failed to get paginated favorites: $e');
    }
  }

  // Search within favorites
  @override
  Future<List<FavoriteMovie>> searchFavorites(String query) async {
    try {
      final allFavorites = await getAllFavorites();

      if (query.isEmpty) {
        return allFavorites;
      }

      final lowerQuery = query.toLowerCase();
      return allFavorites.where((movie) {
        return movie.title.toLowerCase().contains(lowerQuery) ||
            movie.overview.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search favorites: $e');
    }
  }

  // Close the box (useful for cleanup)
  Future<void> close() async {
    if (_favoritesBox != null && _favoritesBox!.isOpen) {
      await _favoritesBox!.close();
    }
  }

  // Compact the box (optimize storage)
  @override
  Future<void> compact() async {
    try {
      final box = await _getBox();
      await box.compact();
    } catch (e) {
      throw Exception('Failed to compact favorites box: $e');
    }
  }

  // Export favorites (for backup)
  @override
  Future<Map<String, dynamic>> exportFavorites() async {
    try {
      final favorites = await getAllFavorites();
      return {
        'favorites': favorites
            .map(
              (movie) => {
                'id': movie.id,
                'title': movie.title,
                'posterPath': movie.posterPath,
                'voteAverage': movie.voteAverage,
                'releaseDate': movie.releaseDate,
                'overview': movie.overview,
                'addedAt': movie.addedAt.toIso8601String(),
                'voteCount': movie.voteCount,
                'genreIds': movie.genreIds,
              },
            )
            .toList(),
        'exportedAt': DateTime.now().toIso8601String(),
        'count': favorites.length,
      };
    } catch (e) {
      throw Exception('Failed to export favorites: $e');
    }
  }
}
