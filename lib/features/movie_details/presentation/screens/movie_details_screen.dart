import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/show_toast.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../controller/bloc/movie_details_bloc.dart';
import '../controller/bloc/movie_details_event.dart';
import '../controller/bloc/movie_details_state.dart';
import '../components/details_backdrop_app_bar.dart';
import '../components/details_header.dart';
import '../components/additional_info_section.dart';
import '../components/overview_section.dart';
import '../components/movie_details_favorite_button.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailsBloc>().add(
      LoadMovieDetailsEvent(movieId: widget.movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      body: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
        listener: (context, state) {
          if (state.hasError) {
            showSnackBar(
              state.errorMessage ?? 'Something went wrong',
              context,
              false,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading();
          }

          if (state.hasError && !state.hasData) {
            return AppErrorView(
              isFromMovieDetails: true,
              message: state.errorMessage ?? 'Failed to load movie details',
              onRetry: () {
                context.read<MovieDetailsBloc>().add(
                  RetryLoadingMovieDetailsEvent(movieId: widget.movieId),
                );
              },
            );
          }

          if (state.hasData) {
            final movie = state.movieDetails!;
            return CustomScrollView(
              slivers: [
                DetailsBackdropAppBar(movie: movie),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailsHeader(movie: movie),
                        verticalSpace(24.h),
                        _buildTopInfoRow(movie),
                        verticalSpace(24.h),
                        OverviewSection(movie: movie),
                        verticalSpace(24.h),
                        AdditionalInfoSection(movie: movie),
                        verticalSpace(32.h),
                        MovieDetailsFavoriteButton(movieDetails: movie),
                        verticalSpace(32.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: AppLoading());
        },
      ),
    );
  }

  Widget _buildTopInfoRow(movie) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard('Status', movie.status, Icons.info_outline),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: _buildInfoCard(
            'Language',
            movie.originalLanguage.toUpperCase(),
            Icons.language,
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: _buildInfoCard(
            'Votes',
            movie.voteCount.toString(),
            Icons.how_to_vote,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: ColorsManager.primary, size: 24.sp),
          verticalSpace(8.h),
          Text(
            label,
            style: TextStyles.font12Primary500.copyWith(
              color: ColorsManager.textSecondary,
            ),
          ),
          verticalSpace(4.h),
          Text(
            value,
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
