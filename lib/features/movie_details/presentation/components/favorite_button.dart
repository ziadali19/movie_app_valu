import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../favorites/controller/bloc/favorites_bloc.dart';
import '../../../favorites/controller/bloc/favorites_event.dart';
import '../../../favorites/controller/bloc/favorites_state.dart';
import '../../../movie_details/data/models/movie_details.dart';

class MovieDetailsFavoriteButton extends StatelessWidget {
  final MovieDetails movieDetails;

  const MovieDetailsFavoriteButton({super.key, required this.movieDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(movieDetails.id);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final favoritesBloc = context.read<FavoritesBloc>();
              favoritesBloc.add(
                ToggleFavoriteFromDetailsEvent(movieDetails: movieDetails),
              );
            },
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
              backgroundColor: isFavorite
                  ? ColorsManager.accentRed
                  : ColorsManager.primary,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
