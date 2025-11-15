import 'package:dartz/dartz.dart';
import 'package:movie_app_valu/features/movie_details/domain/entities/movie_details_entity.dart';

import '../../../../core/network/failure_model.dart';
import '../../../../core/network/generic_response.dart';

abstract class BaseMovieDetailsRepository {
  Future<Either<ApiErrorModel, ApiResponse<MovieDetails>>> getMovieDetails({
    required int movieId,
  });
}
