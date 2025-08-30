import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:movie_app_valu/core/helpers/extensions.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';

class FavoritesInfo extends StatelessWidget {
  final FavoritesState state;

  const FavoritesInfo({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final displayList = state.displayList;
    final isSearching = state.isSearching;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            isSearching
                ? '${displayList.length} result${displayList.length == 1 ? '' : 's'} for "${state.searchQuery}"'
                : '${state.favoritesCount} favorite${state.favoritesCount == 1 ? '' : 's'}',
            style: TextStyle(
              color: ColorsManager.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (!isSearching && state.hasFavorites)
            SvgPicture.asset(
              'bold-heart'.svgPath(),
              width: 16.w,
              height: 16.w,
              colorFilter: ColorFilter.mode(
                ColorsManager.accentRed,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
