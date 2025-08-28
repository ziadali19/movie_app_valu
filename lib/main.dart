import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:movie_app_valu/core/helpers/bloc_observer.dart';
import 'package:movie_app_valu/core/services/service_locator.dart';
import 'package:movie_app_valu/core/services/shared_perferences.dart';
import 'package:movie_app_valu/movie_app_valu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();

  Intl.systemLocale = await findSystemLocale();
  initializeDateFormatting(Intl.systemLocale);
  ServiceLocator.init();
  await CacheHelper.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Bloc.observer = MyBlocObserver();
  runApp(const MovieAppValu());
}
