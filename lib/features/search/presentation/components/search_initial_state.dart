import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';

class SearchInitialState extends StatelessWidget {
  const SearchInitialState({super.key});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
              color: ColorsManager.textSecondary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(8.h),
          Text(
            'Type in the search box above to get started',
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
