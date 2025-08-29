import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/helpers/show_toast.dart';
import 'package:movie_app_valu/core/routing/routes.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/theming/styles.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/core/widgets/app_error_view.dart';
import 'package:movie_app_valu/core/widgets/app_loading.dart';
import 'package:movie_app_valu/core/widgets/elevated_button_without_icon.dart';

import '../../../../core/widgets/error_header.dart';
import '../../controller/bloc/movies_bloc.dart';
import '../../controller/bloc/movies_event.dart';
import '../../controller/bloc/movies_state.dart';
import '../components/movie_card.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load movies when screen initializes
    context.read<MoviesBloc>().add(LoadMoviesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MoviesBloc>().add(LoadMoreMoviesEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(title: Text('Popular Movies')),
      body: BlocListener<MoviesBloc, MoviesState>(
        // listenWhen: (previous, current) =>
        //     previous.status != current.status ||
        //     previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.hasError) {
            // Show error only if no data is available
            showSnackBar(
              state.errorMessage ?? 'Something went wrong',
              context,
              false,
            );
          }
        },
        child: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return _buildLoadingState();
            }

            if (state.hasError && !state.hasData) {
              return _buildErrorState(state.errorMessage);
            }

            if (state.hasData) {
              return _buildMoviesList(state);
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const AppLoading();
  }

  Widget _buildErrorState(String? errorMessage) {
    return AppErrorView(
      message: errorMessage ?? 'Failed to load movies',
      onRetry: () => context.read<MoviesBloc>().add(RetryLoadingMoviesEvent()),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, size: 64.sp, color: ColorsManager.textSecondary),
          verticalSpace(16.h),
          Text(
            'Welcome to CineScout',
            style: TextStyles.font20Black700.copyWith(
              color: ColorsManager.textPrimary,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'Discover amazing movies',
            style: TextStyles.font14Black400.copyWith(
              color: ColorsManager.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(MoviesState state) {
    return Column(
      children: [
        // Error banner for when we have data but an error occurred
        if (state.hasError && state.hasData)
          ErrorHeader(
            errorMessage: state.errorMessage ?? 'Failed to load new content',
            onRetry: () {
              if (state.hasData) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                context.read<MoviesBloc>().add(RetryLoadingMoviesEvent());
              } else {
                context.read<MoviesBloc>().add(RetryLoadingMoviesEvent());
              }
            },
          ),

        // Movies list with refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<MoviesBloc>().add(RefreshMoviesEvent());
            },
            color: ColorsManager.primary,
            backgroundColor: ColorsManager.cardBackground,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Movies List
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return MovieCard(
                      movie: state.movies[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.movieDetails,
                          arguments: state.movies[index].id,
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

                          buttonText: 'Load More Movies',
                          onPressed: () {
                            context.read<MoviesBloc>().add(
                              LoadMoreMoviesEvent(),
                            );
                          },
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
                          style: TextStyles.font14Black400.copyWith(
                            color: ColorsManager.textSecondary,
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
        ),
      ],
    );
  }
}
