import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theming/colors.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.svgIcon,
    required this.svgActiveIcon,

    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String svgIcon;
  final String svgActiveIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isSelected ? 4.w : 2.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorsManager.primary.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              isSelected ? svgActiveIcon : svgIcon,
              width: isSelected ? 26.sp : 24.sp,
              height: isSelected ? 26.sp : 24.sp,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? ColorsManager.primary
                    : ColorsManager.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(height: 4.h),
          if (isSelected)
            // Label with animation
            Container(
              width: 5.w,
              height: 5.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.primary,
              ),
            ),
        ],
      ),
    );
  }
}
