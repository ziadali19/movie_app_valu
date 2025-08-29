import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_bloc.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_event.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_state.dart';
import 'package:movie_app_valu/features/movies/data/models/movie.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';

class FavoriteButton extends StatefulWidget {
  final Movie? movie;
  final MovieDetails? movieDetails;
  final double size;
  final bool showBackground;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    this.movie,
    this.movieDetails,
    this.size = 24.0,
    this.showBackground = true,
    this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  int get movieId => widget.movie?.id ?? widget.movieDetails!.id;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Check favorite status when widget initializes
    context.read<FavoritesBloc>().add(
      CheckFavoriteStatusEvent(movieId: movieId),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFavoritePressed() {
    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Toggle favorite
    if (widget.movie != null) {
      context.read<FavoritesBloc>().add(
        ToggleFavoriteEvent(movie: widget.movie!),
      );
    } else if (widget.movieDetails != null) {
      context.read<FavoritesBloc>().add(
        ToggleFavoriteFromDetailsEvent(movieDetails: widget.movieDetails!),
      );
    }

    // Call optional callback
    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(movieId);

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: InkWell(
                  onTap: _onFavoritePressed,
                  child: Container(
                    width: widget.showBackground
                        ? widget.size + 16.w
                        : widget.size,
                    height: widget.showBackground
                        ? widget.size + 16.w
                        : widget.size,
                    decoration: widget.showBackground
                        ? BoxDecoration(
                            color: AppColors.cardBackground.withOpacity(0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFavorite
                                  ? AppColors.accentRed.withOpacity(0.3)
                                  : AppColors.lightGray.withOpacity(0.2),
                              width: 2.w,
                            ),
                          )
                        : null,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFavorite),
                          size: widget.size,
                          color: isFavorite
                              ? AppColors.accentRed
                              : AppColors.lightGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
