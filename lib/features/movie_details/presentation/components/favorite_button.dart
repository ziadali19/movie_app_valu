import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.onPressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
          size: 20.sp,
        ),
        label: Text(
          isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          style: TextStyles.font16Primary400.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
