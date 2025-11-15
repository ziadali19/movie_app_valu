import 'package:get_it/get_it.dart';
import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/features/favorites/controller/bloc/favorites_bloc.dart';
import 'package:movie_app_valu/features/favorites/data/local_data_source/favorites_local_data_source.dart';
import 'package:movie_app_valu/features/favorites/data/repository/favorites_repository.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';
import 'package:movie_app_valu/features/movie_details/domain/repository/base_movie_details_repository.dart';
import 'package:movie_app_valu/features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movie_app_valu/features/movie_details/presentation/controller/bloc/movie_details_bloc.dart';
import 'package:movie_app_valu/features/movie_details/data/remote_data_source/movie_details_remote_data_source.dart';
import 'package:movie_app_valu/features/movie_details/data/repository/movie_details_repository.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_bloc.dart';
import 'package:movie_app_valu/features/movies/data/remote_data_source/movies_remote_data_source.dart';
import 'package:movie_app_valu/features/movies/data/repository/movies_repository.dart';
import 'package:movie_app_valu/features/search/controller/bloc/search_bloc.dart';
import 'package:movie_app_valu/features/search/data/remote_data_source/search_remote_data_source.dart';
import 'package:movie_app_valu/features/search/data/repository/search_repository.dart';

GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // Navigation Dependencies
    _registerNavigationDependencies();

    // Movies Feature Dependencies
    _registerMoviesDependencies();

    // Search Feature Dependencies
    _registerSearchDependencies();

    // Movie Details Feature Dependencies
    _registerMovieDetailsDependencies();

    // Favorites Feature Dependencies
    _registerFavoritesDependencies();
  }

  static void _registerNavigationDependencies() {
    // Register MainNavigationBloc as LazySingleton (single instance across app)
    getIt.registerLazySingleton<MainNavigationBloc>(() => MainNavigationBloc());
  }

  static void _registerMoviesDependencies() {
    // Register MoviesBloc as Factory (new instance each time)
    getIt.registerFactory<MoviesBloc>(() => MoviesBloc(getIt()));

    // Register MoviesRepository as LazySingleton (single instance)
    getIt.registerLazySingleton<BaseMoviesRepository>(
      () => MoviesRepository(getIt()),
    );

    // Register MoviesRemoteDataSource as LazySingleton
    getIt.registerLazySingleton<BaseMoviesRemoteDataSource>(
      () => MoviesRemoteDataSource(DioHelper.instance),
    );
  }

  static void _registerSearchDependencies() {
    // Register SearchBloc as Factory (new instance each time)
    getIt.registerFactory<SearchBloc>(() => SearchBloc(getIt()));

    // Register SearchRepository as LazySingleton (single instance)
    getIt.registerLazySingleton<BaseSearchRepository>(
      () => SearchRepository(getIt()),
    );

    // Register SearchRemoteDataSource as LazySingleton
    getIt.registerLazySingleton<BaseSearchRemoteDataSource>(
      () => SearchRemoteDataSource(DioHelper.instance),
    );
  }

  static void _registerMovieDetailsDependencies() {
    // Register MovieDetailsBloc as Factory (new instance each time)
    getIt.registerFactory<MovieDetailsBloc>(() => MovieDetailsBloc(getIt()));

    // Register MovieDetailsRepository as LazySingleton (single instance)
    getIt.registerLazySingleton<BaseMovieDetailsRepository>(
      () => MovieDetailsRepository(getIt()),
    );
    getIt.registerLazySingleton<GetMovieDetailsUsecase>(
      () => GetMovieDetailsUsecase(getIt()),
    );
    // Register MovieDetailsRemoteDataSource as LazySingleton
    getIt.registerLazySingleton<BaseMovieDetailsRemoteDataSource>(
      () => MovieDetailsRemoteDataSource(DioHelper.instance),
    );
  }

  static void _registerFavoritesDependencies() {
    // Register FavoritesBloc as LazySingleton (single instance across app)
    // This allows sharing favorite status across the entire app
    getIt.registerLazySingleton<FavoritesBloc>(() => FavoritesBloc(getIt()));

    // Register FavoritesRepository as LazySingleton (single instance)
    getIt.registerLazySingleton<BaseFavoritesRepository>(
      () => FavoritesRepository(getIt()),
    );

    // Register FavoritesLocalDataSource as LazySingleton
    getIt.registerLazySingleton<BaseFavoritesLocalDataSource>(
      () => FavoritesLocalDataSource(),
    );
  }
}
