import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/show_toast.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/elevated_button_without_icon.dart';
import '../../../../core/widgets/error_header.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../movies/presentation/components/movie_card.dart';
import '../../controller/bloc/search_bloc.dart';
import '../../controller/bloc/search_event.dart';
import '../../controller/bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Movies')),
      backgroundColor: ColorsManager.background,
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return CustomSearchBar(
                  controller: _searchController,
                  hintText: 'Search for movies...',
                  onChanged: (query) {
                    context.read<SearchBloc>().add(
                      SearchMoviesEvent(query: query),
                    );
                  },
                  onClear: () {
                    _searchController.clear();
                    context.read<SearchBloc>().add(ClearSearchEvent());
                  },
                  isSearching: state.isSearching,
                );
              },
            ),
            Expanded(child: _buildSearchBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody() {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.hasError && state.errorMessage != null) {
          showSnackBar(state.errorMessage!, context, false);
        }
      },
      builder: (context, state) {
        if (state.isInitial) {
          return _buildInitialState();
        }

        if (state.isSearching && !state.hasResults) {
          return const AppLoading();
        }

        if (state.hasError && !state.hasResults) {
          return AppErrorView(
            message: state.errorMessage ?? 'Search failed',
            onRetry: () {
              context.read<SearchBloc>().add(RetrySearchEvent());
            },
          );
        }

        if (state.isEmpty) {
          return _buildEmptyState(state.query);
        }

        if (state.hasResults) {
          return _buildSearchResults(state);
        }

        return _buildInitialState();
      },
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80.sp,
            color: ColorsManager.textSecondary.withOpacity(0.5),
          ),
          verticalSpace(24.h),
          Text(
            'Search for your favorite movies',
            style: TextStyles.font18Primary600.copyWith(
              color: ColorsManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(8.h),
          Text(
            'Type in the search box above to get started',
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textSecondary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 80.sp,
            color: ColorsManager.textSecondary.withOpacity(0.5),
          ),
          verticalSpace(24.h),
          Text(
            'No movies found',
            style: TextStyles.font18Primary600.copyWith(
              color: ColorsManager.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'No results for "$query"',
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(8.h),
          Text(
            'Try searching with different keywords',
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textSecondary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(SearchState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: ColorsManager.surface,
      child: Row(
        children: [
          Text(
            '${state.movies.length} results for "${state.query}"',
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (state.isSearching)
            SizedBox(
              width: 16.w,
              height: 16.h,
              child: const CupertinoActivityIndicator(
                color: ColorsManager.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    return Column(
      children: [
        _buildResultsHeader(state),
        if (state.hasError && state.hasResults)
          ErrorHeader(
            errorMessage: state.errorMessage ?? 'Failed to load more results',
            onRetry: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
            },
          ),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Movies list
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final movie = state.movies[index];
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
                }, childCount: state.movies.length),
              ),

              // Loading More Indicator
              if (state.isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: ColorsManager.primary,
                      ),
                    ),
                  ),
                ),

              // Load More Button (if not loading and has more pages)
              if (!state.isLoadingMore && state.canLoadMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Center(
                      child: CustomElevatedButtonWithOutIcon(
                        verticalPadding: 12.h,
                        horizontalPadding: 24.w,
                        borderRadius: 8.r,

                        buttonText: 'Load More Results',
                        onPressed: () => context.read<SearchBloc>().add(
                          LoadMoreSearchResultsEvent(),
                        ),
                      ),
                    ),
                  ),
                ),

              // End of List Message
              if (!state.hasMorePages)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Center(
                      child: Text(
                        'You\'ve reached the end!',
                        style: TextStyles.font14Primary700.copyWith(
                          color: ColorsManager.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom padding
              SliverToBoxAdapter(child: verticalSpace(20.h)),
            ],
          ),
        ),
      ],
    );
  }

  // Deprecated in favor of CustomScrollView above, kept for reference if needed
}
