import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/core/network/exceptions.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';

import '../../../movies/data/models/movie.dart';

abstract class BaseSearchRemoteDataSource {
  Future<ApiResponse<List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  });
}

class SearchRemoteDataSource implements BaseSearchRemoteDataSource {
  final DioHelper dioHelper;

  SearchRemoteDataSource(this.dioHelper);

  @override
  Future<ApiResponse<List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await dioHelper.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page},
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

      // Use the same flexible TMDB paginated factory as movies
      return ApiResponse<List<Movie>>.fromTMDBPaginated(
        json: jsonData,
        results: moviesList,
        statusCode: response.statusCode!,
      );
    } catch (e) {
      throw FailException(exception: e);
    }
  }
}
