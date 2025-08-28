import 'package:get_it/get_it.dart';
import 'package:movie_app_valu/core/network/dio_helper.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_bloc.dart';
import 'package:movie_app_valu/features/movies/data/remote_data_source/movies_remote_data_source.dart';
import 'package:movie_app_valu/features/movies/data/repository/movies_repository.dart';

GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // Navigation Dependencies
    _registerNavigationDependencies();

    // Movies Feature Dependencies
    _registerMoviesDependencies();
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
}
