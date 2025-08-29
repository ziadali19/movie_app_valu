import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/routing/routes.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/widgets/elevated_button_without_icon.dart';
import 'package:movie_app_valu/core/widgets/error_header.dart';
import '../../../movies/presentation/components/movie_card.dart';
import '../../controller/bloc/search_bloc.dart';
import '../../controller/bloc/search_event.dart';
import '../../controller/bloc/search_state.dart';
import 'search_results_header.dart';

class SearchResults extends StatelessWidget {
  final SearchState state;
  final ScrollController scrollController;

  const SearchResults({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchResultsHeader(state: state),
        if (state.hasError && state.hasResults)
          ErrorHeader(
            errorMessage: state.errorMessage ?? 'Failed to load more results',
            onRetry: () {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
            },
          ),
        Expanded(
          child: CustomScrollView(
            controller: scrollController,
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
                        style: TextStyle(
                          color: ColorsManager.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        ),
      ],
    );
  }
}
