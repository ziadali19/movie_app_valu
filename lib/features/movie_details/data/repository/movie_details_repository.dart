import 'package:dartz/dartz.dart';
import 'package:movie_app_valu/core/network/api_error_handler.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';
import 'package:movie_app_valu/features/movie_details/domain/entities/movie_details_entity.dart';

import '../../domain/repository/base_movie_details_repository.dart';
import '../remote_data_source/movie_details_remote_data_source.dart';

class MovieDetailsRepository implements BaseMovieDetailsRepository {
  final BaseMovieDetailsRemoteDataSource remoteDataSource;

  MovieDetailsRepository(this.remoteDataSource);

  @override
  Future<Either<ApiErrorModel, ApiResponse<MovieDetails>>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      final ApiResponse<MovieDetailsModel> result = await remoteDataSource
          .getMovieDetails(movieId: movieId);
      return Right(result);
    } on FailException catch (e) {
      return Left(ErrorHandler.instance.handleError(e.exception));
    }
  }
}
