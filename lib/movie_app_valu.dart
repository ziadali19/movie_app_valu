import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/helpers/sizes_config.dart';
import 'package:movie_app_valu/core/theming/themes.dart';
import 'package:movie_app_valu/core/utils/constants.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/services/service_locator.dart';
import 'features/favorites/controller/bloc/favorites_bloc.dart';

class MovieAppValu extends StatelessWidget {
  const MovieAppValu({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: SizesConfig(context).isDesktop
          ? const Size(1440, 905)
          : SizesConfig(context).isTablet
          ? const Size(600, 900)
          : const Size(411.42857142857144, 843.4285714285714),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<FavoritesBloc>(),
          child: MaterialApp(
            navigatorKey: AppConstants.navKey,
            initialRoute: Routes.mainNavigation,
            onGenerateRoute: (settings) {
              return AppRouter.onGenerateRoute(settings);
            },
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);

              return MediaQuery(
                data: mediaQueryData.copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            theme: Themes.instance.darkTheme(context),
          ),
        );
      },
    );
  }
}
