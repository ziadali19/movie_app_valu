import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/core/services/service_locator.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';

class EmptyFavoritesState extends StatelessWidget {
  const EmptyFavoritesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.w,
              color: ColorsManager.textSecondary,
            ),
            verticalSpace(24.h),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                color: ColorsManager.textPrimary,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpace(12.h),
            Text(
              'Start adding movies to your favorites by tapping the heart icon on any movie card.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorsManager.textSecondary,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
            verticalSpace(32.h),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to movies list
                final mainNavigationBloc = getIt<MainNavigationBloc>();
                mainNavigationBloc.add(
                  ChangeNavBarTabEvent(index: 0),
                ); // Movies tab
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(
                Icons.movie_outlined,
                color: ColorsManager.textPrimary,
                size: 20.w,
              ),
              label: Text(
                'Discover Movies',
                style: TextStyle(
                  color: ColorsManager.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primary,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
