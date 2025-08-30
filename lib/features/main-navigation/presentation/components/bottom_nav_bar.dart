import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/helpers/extensions.dart';

import '../../../../core/theming/colors.dart';
import 'nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavItem(
            svgIcon: 'movie'.svgPath(),
            svgActiveIcon: 'movie'.svgPath(),

            label: 'Movies',
            isSelected: index == 0,
            onTap: () => onTap?.call(0),
          ),
          NavItem(
            svgIcon: 'search'.svgPath(),
            svgActiveIcon: 'search'.svgPath(),

            label: 'Search',
            isSelected: index == 1,
            onTap: () => onTap?.call(1),
          ),
          NavItem(
            svgIcon: 'heart'.svgPath(),
            svgActiveIcon: 'bold-heart'.svgPath(),
            label: 'Favorites',
            isSelected: index == 2,
            onTap: () => onTap?.call(2),
          ),
        ],
      ),
    );
  }
}
