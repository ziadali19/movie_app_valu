import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import 'nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,

      decoration: BoxDecoration(
        color: ColorsManager.secondary,
        borderRadius: BorderRadius.circular(24.r),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavItem(
              icon: Icons.movie_outlined,
              activeIcon: Icons.movie,
              label: 'Movies',
              isSelected: index == 0,
              onTap: () => onTap?.call(0),
            ),
            NavItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              label: 'Search',
              isSelected: index == 1,
              onTap: () => onTap?.call(1),
            ),
            NavItem(
              icon: Icons.favorite_outline,
              activeIcon: Icons.favorite,
              label: 'Favorites',
              isSelected: index == 2,
              onTap: () => onTap?.call(2),
            ),
          ],
        ),
      ),
    );
  }
}
