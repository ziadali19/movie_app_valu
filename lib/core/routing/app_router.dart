import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_valu/core/services/service_locator.dart';
import 'package:movie_app_valu/features/movies/controller/bloc/movies_bloc.dart';
import 'package:movie_app_valu/features/movies/presentation/screens/movies_list_screen.dart';

import 'routes.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.moviesList:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<MoviesBloc>(),
            child: const MoviesListScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<MoviesBloc>(),
            child: const MoviesListScreen(),
          ),
        );
    }
  }
}
