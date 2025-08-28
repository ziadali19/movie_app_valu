import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
    // getIt.registerLazySingleton<BaseAuthRemoteDataSource>(
    //     () => AuthRemoteDataSource(DioHelper.instance));
    // getIt.registerLazySingleton<BaseAuthRepository>(
    //     () => AuthRepository(getIt()));
  }
}
