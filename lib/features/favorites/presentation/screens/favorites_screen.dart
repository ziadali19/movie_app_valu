import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_app_valu/core/routing/routes.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/core/services/service_locator.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/widgets/app_loading.dart';
import 'package:movie_app_valu/core/widgets/app_error_view.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_bloc.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_event.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';
import 'package:movie_app_valu/features/movies/presentation/components/movie_card.dart';

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
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          'Clear All Favorites',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all movies from your favorites? This action cannot be undone.',
          style: TextStyle(color: AppColors.lightGray, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.lightGray, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FavoritesBloc>().add(ClearAllFavoritesEvent());
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.accentRed,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text('My Favorites'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.hasFavorites) {
                return PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.white,
                    size: 24.w,
                  ),
                  color: AppColors.cardBackground,
                  onSelected: (value) {
                    switch (value) {
                      case 'clear_all':
                        _clearAllFavorites();
                        break;
                      case 'refresh':
                        _onRefresh();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            color: AppColors.white,
                            size: 20.w,
                          ),
                          horizontalSpace(8.w),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(
                            Icons.clear_all,
                            color: AppColors.accentRed,
                            size: 20.w,
                          ),
                          horizontalSpace(8.w),
                          Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppColors.accentRed,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          horizontalSpace(8.w),
        ],
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
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Search bar (only show if has favorites)
              if (state.hasFavorites) _buildSearchBar(state),

              // Favorites count and info
              if (state.hasFavorites) _buildFavoritesInfo(state),

              // Favorites grid
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _onRefresh(),
                  color: ColorsManager.primary,
                  backgroundColor: AppColors.cardBackground,
                  child: _buildFavoritesGrid(state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(FavoritesState state) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: TextField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(color: AppColors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: 'Search favorites...',
          hintStyle: TextStyle(color: AppColors.lightGray, fontSize: 16.sp),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.lightGray,
            size: 24.w,
          ),
          suffixIcon: state.isSearching
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.lightGray,
                    size: 20.w,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsManager.primary, width: 1.w),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesInfo(FavoritesState state) {
    final displayList = state.displayList;
    final isSearching = state.isSearching;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            isSearching
                ? '${displayList.length} result${displayList.length == 1 ? '' : 's'} for "${state.searchQuery}"'
                : '${state.favoritesCount} favorite${state.favoritesCount == 1 ? '' : 's'}',
            style: TextStyle(
              color: AppColors.lightGray,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (!isSearching && state.hasFavorites)
            Icon(Icons.favorite, color: AppColors.accentRed, size: 16.w),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(FavoritesState state) {
    final displayList = state.displayList;

    if (state.isSearching && displayList.isEmpty) {
      return _buildNoSearchResults();
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80.w, color: AppColors.lightGray),
            verticalSpace(24.h),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpace(12.h),
            Text(
              'Start adding movies to your favorites by tapping the heart icon on any movie card.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightGray,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
            verticalSpace(32.h),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to movies list
                final mainNavigationBloc = getIt<MainNavigationBloc>();
                mainNavigationBloc.add(
                  ChangeNavBarTabEvent(index: 0),
                ); // Movies tab
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(
                Icons.movie_outlined,
                color: AppColors.white,
                size: 20.w,
              ),
              label: Text(
                'Discover Movies',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60.w, color: AppColors.lightGray),
            verticalSpace(16.h),
            Text(
              'No Results Found',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            verticalSpace(8.h),
            Text(
              'Try searching with different keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightGray, fontSize: 14.sp),
            ),
            verticalSpace(16.h),
            TextButton(
              onPressed: _clearSearch,
              child: Text(
                'Clear Search',
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
