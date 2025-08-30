import 'package:flutter/material.dart';
import 'package:movie_app_valu/core/routing/routes.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';
import 'package:movie_app_valu/features/movies/presentation/components/movie_card.dart';
import 'no_search_results.dart';

class FavoritesGrid extends StatelessWidget {
  final FavoritesState state;
  final VoidCallback onClearSearch;

  const FavoritesGrid({
    super.key,
    required this.state,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final displayList = state.displayList;

    if (state.isSearching && displayList.isEmpty) {
      return NoSearchResults(onClearSearch: onClearSearch);
    }

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final favoriteMovie = displayList[index];
        final movie = favoriteMovie.toMovie();

        return MovieCard(
          movie: movie,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.movieDetails,
              arguments: movie.id,
            );
          },
        );
      },
    );
  }
}
