import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
                  ? ColorsManager.primary.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: isSelected ? 26.sp : 24.sp,
              color: isSelected
                  ? ColorsManager.primary
                  : ColorsManager.textSecondary,
            ),
          ),

          SizedBox(height: 4.h),

          // Label with animation
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: isSelected
                ? TextStyles.font12Primary500.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary,
                    fontFamily: 'IBMPlexSans',
                  )
                : TextStyles.font10Primary400.copyWith(
                    color: ColorsManager.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'IBMPlexSans',
                  ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
