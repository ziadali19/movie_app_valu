import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';

class NoSearchResults extends StatelessWidget {
  final VoidCallback onClearSearch;

  const NoSearchResults({super.key, required this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60.w,
              color: ColorsManager.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Results Found',
              style: TextStyle(
                color: ColorsManager.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try searching with different keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorsManager.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onClearSearch,
              child: Text(
                'Clear Search',
                style: TextStyle(
                  color: ColorsManager.primary,
                  fontSize: 14.sp,
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
