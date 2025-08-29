import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/core/helpers/spacing.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_bloc.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClearAll;
  final VoidCallback onRefresh;

  const FavoritesAppBar({
    super.key,
    required this.onClearAll,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My Favorites'),
      actions: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.hasFavorites) {
              return PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: ColorsManager.textPrimary,
                  size: 24.w,
                ),
                color: ColorsManager.cardBackground,
                onSelected: (value) {
                  switch (value) {
                    case 'clear_all':
                      onClearAll();
                      break;
                    case 'refresh':
                      onRefresh();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: ColorsManager.textPrimary,
                          size: 20.w,
                        ),
                        horizontalSpace(8.w),
                        Text(
                          'Refresh',
                          style: TextStyle(
                            color: ColorsManager.textPrimary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(
                          Icons.clear_all,
                          color: ColorsManager.accentRed,
                          size: 20.w,
                        ),
                        horizontalSpace(8.w),
                        Text(
                          'Clear All',
                          style: TextStyle(
                            color: ColorsManager.accentRed,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        horizontalSpace(8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
