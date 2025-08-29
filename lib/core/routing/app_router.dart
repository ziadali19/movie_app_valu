import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_valu/core/services/service_locator.dart';
import 'package:movie_app_valu/features/main-navigation/controller/bloc/main_navigation_bloc.dart';
import 'package:movie_app_valu/features/main-navigation/presentation/screens/main-navigation_screen.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_bloc.dart';
import 'package:movie_app_valu/features/movies/presentation/screens/movies_list_screen.dart';
import 'package:movie_app_valu/features/search/controller/bloc/search_bloc.dart';

import 'routes.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainNavigation:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<MainNavigationBloc>()),
              BlocProvider(create: (context) => getIt<MoviesBloc>()),
              BlocProvider(create: (context) => getIt<SearchBloc>()),
            ],
            child: const MainNavigationScreen(),
          ),
        );

      case Routes.moviesList:
        return MaterialPageRoute(
          builder: (context) => const MoviesListScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<MainNavigationBloc>()),
              BlocProvider(create: (context) => getIt<MoviesBloc>()),
              BlocProvider(create: (context) => getIt<SearchBloc>()),
            ],
            child: const MainNavigationScreen(),
          ),
        );
    }
  }
}
