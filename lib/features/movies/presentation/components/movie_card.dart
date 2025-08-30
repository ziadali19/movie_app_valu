import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/theming/styles.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/features/favorites/presentation/components/favorite_button.dart';

import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorsManager.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            _buildPosterImage(),

            // Movie Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Year Row
                    Row(
                      children: [
                        Expanded(child: _buildMovieTitle()),
                        _buildYearChip(),
                      ],
                    ),

                    verticalSpace(8.h),

                    // Rating Row
                    _buildRatingRow(),

                    verticalSpace(8.h),

                    // Overview
                    _buildOverview(),

                    verticalSpace(8.h),

                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        bottomLeft: Radius.circular(12.r),
      ),
      child: SizedBox(
        width: 100.w,
        height: 178.h,
        child: CachedNetworkImage(
          imageUrl: movie.fullPosterUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[800],
            child: Center(
              child: Icon(Icons.movie, color: Colors.grey[600], size: 32.sp),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.grey[600],
                size: 32.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieTitle() {
    return Text(
      movie.title,
      style: TextStyles.font16Black500.copyWith(
        color: ColorsManager.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildYearChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: ColorsManager.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        movie.formattedYear,
        style: TextStyles.font12Primary500.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16.sp),
        horizontalSpace(4.w),
        Text(
          movie.formattedRating,
          style: TextStyles.font14Black500.copyWith(
            color: ColorsManager.textPrimary,
          ),
        ),
        horizontalSpace(8.w),
        Text(
          '(${movie.voteCount})',
          style: TextStyles.font12Grey500.copyWith(
            color: ColorsManager.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverview() {
    return Text(
      movie.overview,
      style: TextStyles.font12Grey500.copyWith(
        color: ColorsManager.textSecondary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Favorite Button
        FavoriteButton(movie: movie, size: 20.w),

        // More Info Button
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: ColorsManager.primary.withOpacity(0.3)),
            ),
            child: Text(
              'More Info',
              style: TextStyles.font12Primary500.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
