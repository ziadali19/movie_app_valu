import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/movie_details_repository.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final BaseMovieDetailsRepository repository;

  MovieDetailsBloc(this.repository) : super(const MovieDetailsState()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<RetryLoadingMovieDetailsEvent>(_onRetryLoadingMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MovieDetailsStatus.loading,
        movieId: event.movieId,
        errorMessage: null,
      ),
    );

    final result = await repository.getMovieDetails(movieId: event.movieId);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: MovieDetailsStatus.error,
          errorMessage: error.message ?? 'Failed to load movie details',
        ),
      ),
      (apiResponse) => emit(
        state.copyWith(
          status: MovieDetailsStatus.success,
          movieDetails: apiResponse.singleResult,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onRetryLoadingMovieDetails(
    RetryLoadingMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    add(LoadMovieDetailsEvent(movieId: event.movieId));
  }
}
