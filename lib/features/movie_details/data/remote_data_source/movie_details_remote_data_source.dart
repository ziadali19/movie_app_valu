import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';

import '../models/movie_details.dart';

abstract class BaseMovieDetailsRemoteDataSource {
  Future<ApiResponse<MovieDetails>> getMovieDetails({required int movieId});
}

class MovieDetailsRemoteDataSource implements BaseMovieDetailsRemoteDataSource {
  final DioHelper dioHelper;

  MovieDetailsRemoteDataSource(this.dioHelper);

  @override
  Future<ApiResponse<MovieDetails>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      final response = await dioHelper.get('/movie/$movieId');

      final jsonData = response.data as Map<String, dynamic>;
      final movieDetails = MovieDetails.fromJson(jsonData);

      return ApiResponse<MovieDetails>.fromTMDBSingle(
        results: movieDetails,
        statusCode: response.statusCode!,
      );
    } catch (e) {
      throw FailException(exception: e);
    }
  }
}
