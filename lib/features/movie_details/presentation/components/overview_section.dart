import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/movie_details.dart';

class OverviewSection extends StatelessWidget {
  final MovieDetails movie;

  const OverviewSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyles.font18Primary600.copyWith(
            color: ColorsManager.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorsManager.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            movie.overview.isEmpty ? 'No overview available.' : movie.overview,
            style: TextStyles.font14Primary700.copyWith(
              color: ColorsManager.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
