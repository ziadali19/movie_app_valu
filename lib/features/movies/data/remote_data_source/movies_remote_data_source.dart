import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';

import '../models/movie.dart';

abstract class BaseMoviesRemoteDataSource {
  Future<ApiResponse<List<Movie>>> getPopularMovies({int page = 1});
}

class MoviesRemoteDataSource implements BaseMoviesRemoteDataSource {
  final DioHelper dioHelper;

  MoviesRemoteDataSource(this.dioHelper);

  @override
  Future<ApiResponse<List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dioHelper.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      final jsonData = response.data as Map<String, dynamic>;

      // Construct List<Movie> from the results array
      final moviesList =
          (jsonData['results'] as List<dynamic>?)
              ?.map(
                (movieJson) =>
                    Movie.fromJson(movieJson as Map<String, dynamic>),
              )
              .toList() ??
          <Movie>[];

      // Use the new flexible TMDB paginated factory
      return ApiResponse<List<Movie>>.fromTMDBPaginated(
        json: jsonData,
        results: moviesList, // Pass the constructed List<Movie>
        statusCode: response.statusCode!,
      );
    } catch (e) {
      throw FailException(exception: e);
    }
  }
}
