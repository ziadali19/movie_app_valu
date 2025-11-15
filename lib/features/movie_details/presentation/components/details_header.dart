import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../data/models/movie_details.dart';

class DetailsHeader extends StatelessWidget {
  final MovieDetailsModel movie;

  const DetailsHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.w,
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: movie.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: movie.fullPosterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: ColorsManager.surface,
                      child: const AppLoading(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: ColorsManager.surface,
                      child: Icon(
                        Icons.movie,
                        color: ColorsManager.textSecondary,
                        size: 32.sp,
                      ),
                    ),
                  )
                : Container(
                    color: ColorsManager.surface,
                    child: Icon(
                      Icons.movie,
                      color: ColorsManager.textSecondary,
                      size: 32.sp,
                    ),
                  ),
          ),
        ),
        horizontalSpace(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyles.font24Primary700.copyWith(
                  color: ColorsManager.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              verticalSpace(8.h),
              if (movie.tagline?.isNotEmpty == true)
                Text(
                  movie.tagline!,
                  style: TextStyles.font14Primary700.copyWith(
                    color: ColorsManager.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              verticalSpace(12.h),
              _buildRatingChip(movie.voteAverage),
              verticalSpace(8.h),
              Text(
                '${movie.releaseYear} • ${movie.formattedRuntime}',
                style: TextStyles.font14Primary700.copyWith(
                  color: ColorsManager.textSecondary,
                ),
              ),
              verticalSpace(8.h),
              if (movie.genresText.isNotEmpty)
                Text(
                  movie.genresText,
                  style: TextStyles.font14Primary700.copyWith(
                    color: ColorsManager.primary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingChip(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 16.sp),
          horizontalSpace(4.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyles.font14Primary700.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
