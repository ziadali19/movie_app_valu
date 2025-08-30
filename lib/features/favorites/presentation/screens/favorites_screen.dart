import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/widgets/app_loading.dart';
import 'package:movie_app_valu/core/widgets/app_error_view.dart';
import 'package:movie_app_valu/core/widgets/search_bar.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_bloc.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_event.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';
import '../components/clear_all_alert_dialog.dart';
import '../components/empty_favorites_state.dart';
import '../components/favorites_app_bar.dart';
import '../components/favorites_grid.dart';
import '../components/favorites_info.dart';

import '../../../../core/helpers/show_toast.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load favorites when screen initializes
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<FavoritesBloc>().add(SearchFavoritesEvent(query: query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<FavoritesBloc>().add(SearchFavoritesEvent(query: ''));
  }

  void _onRefresh() {
    context.read<FavoritesBloc>().add(RefreshFavoritesEvent());
  }

  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (context) => ClearAllAlertDialog(
        onCancel: () => Navigator.of(context).pop(),
        onClear: () {
          Navigator.of(context).pop();
          context.read<FavoritesBloc>().add(ClearAllFavoritesEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: FavoritesAppBar(
        onClearAll: _clearAllFavorites,
        onRefresh: _onRefresh,
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state.hasError) {
            showSnackBar(
              state.errorMessage ?? 'An error occurred',
              context,
              false,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.favorites.isEmpty) {
            return const AppLoading();
          }

          if (state.hasError && state.favorites.isEmpty) {
            return AppErrorView(
              message: state.errorMessage ?? 'Failed to load favorites',
              onRetry: _onRefresh,
            );
          }

          if (state.isEmpty) {
            return const EmptyFavoritesState();
          }

          return Column(
            children: [
              // Search bar (only show if has favorites)
              if (state.hasFavorites)
                CustomSearchBar(
                  controller: _searchController,
                  hintText: 'Search favorites...',
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                ),

              // Favorites count and info
              if (state.hasFavorites) FavoritesInfo(state: state),

              // Favorites grid
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _onRefresh(),
                  color: ColorsManager.primary,
                  backgroundColor: ColorsManager.cardBackground,
                  child: FavoritesGrid(
                    state: state,
                    onClearSearch: _clearSearch,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
