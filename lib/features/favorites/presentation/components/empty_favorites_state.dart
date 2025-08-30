import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app_valu/core/helpers/extensions.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';

import '../../../../core/theming/styles.dart';

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
            SvgPicture.asset(
              'heart'.svgPath(),
              width: 50.w,
              height: 50.w,
              colorFilter: ColorFilter.mode(
                ColorsManager.textSecondary,
                BlendMode.srcIn,
              ),
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

                context.read<MainNavigationBloc>().add(
                  ChangeNavBarTabEvent(index: 0),
                );
              },
              icon: Icon(
                Icons.movie_outlined,
                color: ColorsManager.textPrimary,
                size: 20.w,
              ),
              label: Text(
                'Discover Movies',
                style: TextStyles.font16Primary400.copyWith(
                  color: ColorsManager.textPrimary,
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
