import 'package:dartz/dartz.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';

import '../local_data_source/favorites_local_data_source.dart';
import '../models/favorite_movie.dart';

abstract class BaseFavoritesRepository {
  Future<Either<ApiErrorModel, List<FavoriteMovie>>> getAllFavorites();
  Future<Either<ApiErrorModel, void>> addToFavorites(Movie movie);
  Future<Either<ApiErrorModel, void>> addMovieDetailsToFavorites(
    MovieDetailsModel movieDetails,
  );
  Future<Either<ApiErrorModel, void>> removeFromFavorites(int movieId);
  Future<Either<ApiErrorModel, bool>> isFavorite(int movieId);
  Future<Either<ApiErrorModel, void>> toggleFavorite(Movie movie);
  Future<Either<ApiErrorModel, void>> toggleFavoriteFromDetails(
    MovieDetailsModel movieDetails,
  );
  Future<Either<ApiErrorModel, void>> clearAllFavorites();
  Future<Either<ApiErrorModel, int>> getFavoritesCount();
  Future<Either<ApiErrorModel, List<FavoriteMovie>>> searchFavorites(
    String query,
  );
}

class FavoritesRepository implements BaseFavoritesRepository {
  final BaseFavoritesLocalDataSource localDataSource;

  FavoritesRepository(this.localDataSource);

  @override
  Future<Either<ApiErrorModel, List<FavoriteMovie>>> getAllFavorites() async {
    try {
      final favorites = await localDataSource.getAllFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to load favorites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> addToFavorites(Movie movie) async {
    try {
      final favoriteMovie = FavoriteMovie.fromMovie(movie);
      await localDataSource.addToFavorites(favoriteMovie);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to add to favorites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> addMovieDetailsToFavorites(
    MovieDetailsModel movieDetails,
  ) async {
    try {
      final favoriteMovie = FavoriteMovie.fromMovieDetails(movieDetails);
      await localDataSource.addToFavorites(favoriteMovie);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to add to favorites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> removeFromFavorites(int movieId) async {
    try {
      await localDataSource.removeFromFavorites(movieId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(
          message: 'Failed to remove from favorites: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> isFavorite(int movieId) async {
    try {
      final isFavorite = await localDataSource.isFavorite(movieId);
      return Right(isFavorite);
    } catch (e) {
      return Left(
        ApiErrorModel(
          message: 'Failed to check favorite status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> toggleFavorite(Movie movie) async {
    try {
      final isFavoriteResult = await localDataSource.isFavorite(movie.id);

      if (isFavoriteResult) {
        // Movie is favorited, remove it
        await localDataSource.removeFromFavorites(movie.id);
      } else {
        // Movie is not favorited, add it
        final favoriteMovie = FavoriteMovie.fromMovie(movie);
        await localDataSource.addToFavorites(favoriteMovie);
      }

      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to toggle favorite: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> toggleFavoriteFromDetails(
    MovieDetailsModel movieDetails,
  ) async {
    try {
      final isFavoriteResult = await localDataSource.isFavorite(
        movieDetails.id,
      );

      if (isFavoriteResult) {
        // Movie is favorited, remove it
        await localDataSource.removeFromFavorites(movieDetails.id);
      } else {
        // Movie is not favorited, add it
        final favoriteMovie = FavoriteMovie.fromMovieDetails(movieDetails);
        await localDataSource.addToFavorites(favoriteMovie);
      }

      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to toggle favorite: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> clearAllFavorites() async {
    try {
      await localDataSource.clearAllFavorites();
      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to clear favorites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, int>> getFavoritesCount() async {
    try {
      final count = await localDataSource.getFavoritesCount();
      return Right(count);
    } catch (e) {
      return Left(
        ApiErrorModel(
          message: 'Failed to get favorites count: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, List<FavoriteMovie>>> searchFavorites(
    String query,
  ) async {
    try {
      final favorites = await localDataSource.searchFavorites(query);
      return Right(favorites);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to search favorites: ${e.toString()}'),
      );
    }
  }

  // Additional helper methods

  Future<Either<ApiErrorModel, List<FavoriteMovie>>> getFavoritesPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final favorites = await localDataSource.getFavoritesPaginated(
        page: page,
        limit: limit,
      );
      return Right(favorites);
    } catch (e) {
      return Left(
        ApiErrorModel(
          message: 'Failed to get paginated favorites: ${e.toString()}',
        ),
      );
    }
  }

  Future<Either<ApiErrorModel, FavoriteMovie?>> getFavoriteById(
    int movieId,
  ) async {
    try {
      final favorite = await localDataSource.getFavoriteById(movieId);
      return Right(favorite);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to get favorite by ID: ${e.toString()}'),
      );
    }
  }

  Future<Either<ApiErrorModel, Map<String, dynamic>>> exportFavorites() async {
    try {
      final exportData = await localDataSource.exportFavorites();
      return Right(exportData);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to export favorites: ${e.toString()}'),
      );
    }
  }

  Future<Either<ApiErrorModel, void>> compactStorage() async {
    try {
      await localDataSource.compact();
      return const Right(null);
    } catch (e) {
      return Left(
        ApiErrorModel(message: 'Failed to compact storage: ${e.toString()}'),
      );
    }
  }
}
