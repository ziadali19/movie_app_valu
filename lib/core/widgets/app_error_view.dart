import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/theming/styles.dart';

import '../../features/main-navigation/controller/bloc/main_navigation_bloc.dart';

class AppErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool isFromMovieDetails;
  const AppErrorView({
    super.key,
    this.message,
    this.onRetry,
    this.isFromMovieDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: ColorsManager.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyles.font18Black600.copyWith(
                color: ColorsManager.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message ?? 'Something went wrong',
              style: TextStyles.font14Black400.copyWith(
                color: ColorsManager.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyles.font16Primary400.copyWith(
                    color: ColorsManager.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!isFromMovieDetails) SizedBox(height: 12.h),
            if (!isFromMovieDetails)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  context.read<MainNavigationBloc>().add(
                    ChangeNavBarTabEvent(index: 2),
                  );
                },
                icon: Icon(
                  Icons.movie_outlined,
                  color: ColorsManager.textPrimary,
                ),
                label: Text(
                  'Discover Your Favorites',
                  style: TextStyles.font16Primary400.copyWith(
                    color: ColorsManager.textPrimary,
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
