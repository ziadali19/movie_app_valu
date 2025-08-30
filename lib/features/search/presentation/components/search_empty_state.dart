import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';

class SearchEmptyState extends StatelessWidget {
  final String query;

  const SearchEmptyState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
              color: ColorsManager.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'No results for "$query"',
            style: TextStyle(
              color: ColorsManager.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(8.h),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              color: ColorsManager.textSecondary.withOpacity(0.7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
