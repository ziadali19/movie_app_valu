import 'package:dartz/dartz.dart';
import 'package:movie_app_valu/core/network/api_error_handler.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failure_model.dart';
import '../../../movies/data/models/movie.dart';
import '../remote_data_source/search_remote_data_source.dart';

abstract class BaseSearchRepository {
  Future<Either<ApiErrorModel, ApiResponse<List<Movie>>>> searchMovies({
    required String query,
    int page = 1,
  });
}

class SearchRepository implements BaseSearchRepository {
  final BaseSearchRemoteDataSource remoteDataSource;

  SearchRepository(this.remoteDataSource);

  @override
  Future<Either<ApiErrorModel, ApiResponse<List<Movie>>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final ApiResponse<List<Movie>> result = await remoteDataSource
          .searchMovies(query: query, page: page);
      return Right(result);
    } on FailException catch (e) {
      return Left(ErrorHandler.instance.handleError(e.exception));
    }
  }
}
