import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../data/models/movie_details.dart';

class DetailsBackdropAppBar extends StatelessWidget {
  final MovieDetails movie;

  const DetailsBackdropAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: ColorsManager.background,
      foregroundColor: ColorsManager.textPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (movie.backdropPath != null)
              CachedNetworkImage(
                imageUrl: movie.fullBackdropUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: ColorsManager.surface,
                  child: const Center(child: AppLoading()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: ColorsManager.surface,
                  child: Icon(
                    Icons.movie,
                    size: 64.sp,
                    color: ColorsManager.textSecondary,
                  ),
                ),
              )
            else
              Container(
                color: ColorsManager.surface,
                child: Icon(
                  Icons.movie,
                  size: 64.sp,
                  color: ColorsManager.textSecondary,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    ColorsManager.background.withOpacity(0.7),
                    ColorsManager.background,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
