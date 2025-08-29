import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final BaseFavoritesRepository repository;

  FavoritesBloc(this.repository) : super(const FavoritesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<AddMovieDetailsToFavoritesEvent>(_onAddMovieDetailsToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleFavoriteFromDetailsEvent>(_onToggleFavoriteFromDetails);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
    on<SearchFavoritesEvent>(_onSearchFavorites);
    on<ClearAllFavoritesEvent>(_onClearAllFavorites);
    on<RefreshFavoritesEvent>(_onRefreshFavorites);
    on<LoadFavoritesCountEvent>(_onLoadFavoritesCount);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading, errorMessage: null));

    final result = await repository.getAllFavorites();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to load favorites',
        ),
      ),
      (favorites) {
        // Create favorite status map for quick lookups
        final favoriteStatus = <int, bool>{};
        for (final favorite in favorites) {
          favoriteStatus[favorite.id] = true;
        }

        emit(
          state.copyWith(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteStatus: favoriteStatus,
            favoritesCount: favorites.length,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.addToFavorites(event.movie);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to add to favorites',
        ),
      ),
      (_) {
        // Update favorite status
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        updatedStatus[event.movie.id] = true;

        emit(
          state.copyWith(
            favoriteStatus: updatedStatus,
            favoritesCount: state.favoritesCount + 1,
          ),
        );

        // Reload favorites to get the updated list
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onAddMovieDetailsToFavorites(
    AddMovieDetailsToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.addMovieDetailsToFavorites(
      event.movieDetails,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to add to favorites',
        ),
      ),
      (_) {
        // Update favorite status
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        updatedStatus[event.movieDetails.id] = true;

        emit(
          state.copyWith(
            favoriteStatus: updatedStatus,
            favoritesCount: state.favoritesCount + 1,
          ),
        );

        // Reload favorites to get the updated list
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.removeFromFavorites(event.movieId);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to remove from favorites',
        ),
      ),
      (_) {
        // Update favorite status
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        updatedStatus[event.movieId] = false;

        emit(
          state.copyWith(
            favoriteStatus: updatedStatus,
            favoritesCount: state.favoritesCount > 0
                ? state.favoritesCount - 1
                : 0,
          ),
        );

        // Reload favorites to get the updated list
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.toggleFavorite(event.movie);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to toggle favorite',
        ),
      ),
      (_) {
        // Update favorite status (toggle current state)
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        final currentStatus = updatedStatus[event.movie.id] ?? false;
        updatedStatus[event.movie.id] = !currentStatus;

        final newCount = !currentStatus
            ? state.favoritesCount + 1
            : (state.favoritesCount > 0 ? state.favoritesCount - 1 : 0);

        emit(
          state.copyWith(
            favoriteStatus: updatedStatus,
            favoritesCount: newCount,
          ),
        );

        // Reload favorites to get the updated list
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onToggleFavoriteFromDetails(
    ToggleFavoriteFromDetailsEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.toggleFavoriteFromDetails(
      event.movieDetails,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to toggle favorite',
        ),
      ),
      (_) {
        // Update favorite status (toggle current state)
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        final currentStatus = updatedStatus[event.movieDetails.id] ?? false;
        updatedStatus[event.movieDetails.id] = !currentStatus;

        final newCount = !currentStatus
            ? state.favoritesCount + 1
            : (state.favoritesCount > 0 ? state.favoritesCount - 1 : 0);

        emit(
          state.copyWith(
            favoriteStatus: updatedStatus,
            favoritesCount: newCount,
          ),
        );

        // Reload favorites to get the updated list
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatusEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.isFavorite(event.movieId);

    result.fold(
      (error) => {}, // Silently fail for status checks
      (isFavorite) {
        final updatedStatus = Map<int, bool>.from(state.favoriteStatus);
        updatedStatus[event.movieId] = isFavorite;

        emit(state.copyWith(favoriteStatus: updatedStatus));
      },
    );
  }

  Future<void> _onSearchFavorites(
    SearchFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    if (event.query.isEmpty) {
      // Clear search
      emit(state.copyWith(searchQuery: '', searchResults: []));
      return;
    }

    emit(state.copyWith(searchQuery: event.query));

    final result = await repository.searchFavorites(event.query);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to search favorites',
        ),
      ),
      (searchResults) => emit(
        state.copyWith(
          searchResults: searchResults,
          status: FavoritesStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onClearAllFavorites(
    ClearAllFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.clearAllFavorites();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.message ?? 'Failed to clear favorites',
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            favorites: [],
            favoriteStatus: {},
            favoritesCount: 0,
            searchQuery: '',
            searchResults: [],
            status: FavoritesStatus.success,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshFavorites(
    RefreshFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    // Reload favorites
    add(LoadFavoritesEvent());
  }

  Future<void> _onLoadFavoritesCount(
    LoadFavoritesCountEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await repository.getFavoritesCount();

    result.fold(
      (error) => {}, // Silently fail for count loading
      (count) => emit(state.copyWith(favoritesCount: count)),
    );
  }
}
