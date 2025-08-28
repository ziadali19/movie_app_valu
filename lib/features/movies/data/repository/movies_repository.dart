import 'package:dartz/dartz.dart';
import 'package:movie_app_valu/core/network/api_error_handler.dart';

import 'package:movie_app_valu/core/network/generic_response.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failure_model.dart';
import '../models/movie.dart';
import '../remote_data_source/movies_remote_data_source.dart';

abstract class BaseMoviesRepository {
  Future<Either<ApiErrorModel, ApiResponse<List<Movie>>>> getPopularMovies({
    int page = 1,
  });
}

class MoviesRepository implements BaseMoviesRepository {
  final BaseMoviesRemoteDataSource remoteDataSource;

  MoviesRepository(this.remoteDataSource);

  @override
  Future<Either<ApiErrorModel, ApiResponse<List<Movie>>>> getPopularMovies({
    int page = 1,
  }) async {
    try {
      final ApiResponse<List<Movie>> result = await remoteDataSource
          .getPopularMovies(page: page);
      return Right(result);
    } on FailException catch (e) {
      return Left(ErrorHandler.instance.handleError(e.exception));
    }
  }
}
